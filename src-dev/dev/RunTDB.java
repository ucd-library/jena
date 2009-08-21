/*
 * (c) Copyright 2007, 2008, 2009 Hewlett-Packard Development Company, LP
 * All rights reserved.
 * [See end of file]
 */

package dev;

import static com.hp.hpl.jena.tdb.sys.Names.tripleIndexes ;

import java.io.FileInputStream ;
import java.io.IOException ;
import java.io.InputStream ;
import java.util.Arrays ;
import java.util.List ;

import junit.framework.TestCase ;
import org.junit.runner.JUnitCore ;
import org.junit.runner.Result ;
import atlas.io.IndentedLineBuffer ;
import atlas.junit.TextListener2 ;
import atlas.logging.Log ;

import com.hp.hpl.jena.query.* ;
import com.hp.hpl.jena.rdf.model.Model ;
import com.hp.hpl.jena.riot.JenaReaderTurtle2 ;
import com.hp.hpl.jena.sparql.algebra.Algebra ;
import com.hp.hpl.jena.sparql.algebra.Op ;
import com.hp.hpl.jena.sparql.algebra.Transformer ;
import com.hp.hpl.jena.tdb.TC_TDB ;
import com.hp.hpl.jena.tdb.TDB ;
import com.hp.hpl.jena.tdb.base.block.BlockMgrMem ;
import com.hp.hpl.jena.tdb.base.file.FileSet ;
import com.hp.hpl.jena.tdb.base.file.Location ;
import com.hp.hpl.jena.tdb.base.file.MetaFile ;
import com.hp.hpl.jena.tdb.base.record.RecordFactory ;
import com.hp.hpl.jena.tdb.index.IndexBuilder ;
import com.hp.hpl.jena.tdb.junit.QueryTestTDB ;
import com.hp.hpl.jena.tdb.nodetable.NodeTable ;
import com.hp.hpl.jena.tdb.nodetable.NodeTableFactory ;
import com.hp.hpl.jena.tdb.solver.reorder.ReorderLib ;
import com.hp.hpl.jena.tdb.solver.reorder.ReorderTransformation ;
import com.hp.hpl.jena.tdb.store.DatasetPrefixesTDB ;
import com.hp.hpl.jena.tdb.store.FactoryGraphTDB ;
import com.hp.hpl.jena.tdb.store.GraphTDB ;
import com.hp.hpl.jena.tdb.store.GraphTriplesTDB ;
import com.hp.hpl.jena.tdb.store.TripleTable ;
import com.hp.hpl.jena.tdb.sys.TDBMaker ;

import dump.DumpIndex ;

public class RunTDB
{
    static String divider = "----------" ;
    static String nextDivider = null ;
    static void divider()
    {
        if ( nextDivider != null )
            System.out.println(nextDivider) ;
        nextDivider = divider ;
    }

    static { Log.setLog4j() ; }

    public static void main(String ... args) throws IOException
    {
        {
            //TDB.setExecutionLogging(true) ;
            tdbquery("--tdb=tdb.ttl", "--file=Q.rq") ;
        }
        
        
        DumpIndex.dump(System.out, "DB", "SPO") ;
        System.exit(0) ;
        
        
        NewSetup.buildDataset(new Location("tmp/DBX")) ;
        System.exit(0) ;
        
        FileSet fileset = new FileSet("tmp", "XYZ") ;
        NewSetup.createRangeIndex(fileset, new RecordFactory(24,0)) ;
        System.exit(0) ;
        metadata() ;
        System.exit(0) ;
    }
    
   
    
    public static void turtle2() throws IOException
        {
            // Also tdb.turtle.
    //        TDB.init();
    //        RDFWriter w = new JenaWriterNTriples2() ;
    //        Model model = FileManager.get().loadModel("D.ttl") ;
    //        w.write(model, System.out, null) ;
    //        System.exit(0) ;
            
            InputStream input = new FileInputStream("D.ttl") ;
            JenaReaderTurtle2.parse(input) ;
            System.out.println("END") ;
            System.exit(0) ;
    
        }



    static void metadata()
    {
        // Directory metadata files.
        Location location = new Location("DB") ;
        //FileSet fileSet = new FileSet(location, "XYZ") ;
        //MetaFile metafile = fileSet.getMetaFile() ;
        MetaFile metafile = location.getMetaFile() ;
        
        System.out.println("Exists meta? "+metafile.existsMetaData()) ;
        metafile.setProperty("item1", "snork") ;
        metafile.flush() ;
        System.out.println("Exists meta? "+metafile.existsMetaData()) ;
        System.out.println("----") ;

        
        metafile.setProperty("item1", "snork") ;
        metafile.flush() ;
        
        String mf = metafile.getFilename() ;
        metafile = new MetaFile("label", mf) ;
        System.out.println(metafile.getProperty("item1")) ;
        System.out.println("----") ;
        System.exit(0) ;
    }
    
    private static GraphTDB setup()
    {
        // Setup a graph - for experimental alternatives.
        BlockMgrMem.SafeMode = false ;
        IndexBuilder indexBuilder = IndexBuilder.mem() ;
        Location location = null ;
        
        NodeTable nodeTable = NodeTableFactory.create(indexBuilder, location) ;
        
        TripleTable table = FactoryGraphTDB.createTripleTable(indexBuilder, nodeTable, location, tripleIndexes) ; 
        ReorderTransformation transform = ReorderLib.identity() ;
        DatasetPrefixesTDB prefixes = DatasetPrefixesTDB.create(indexBuilder, location) ;
        GraphTDB g = new GraphTriplesTDB(null, table, prefixes) ;
        return g ;
    }

    public static void rewrite()
    {
        ReorderTransformation reorder = null ;
        if ( false )
            reorder = ReorderLib.fixed() ;
        else
        {
            reorder = ReorderLib.weighted("stats.sse") ;
        }
        Query query = QueryFactory.read("Q.rq") ;
        Op op = Algebra.compile(query) ;
        System.out.println(op) ;
        
        op = Transformer.transform(new TransformReorderBGP(reorder), op) ;
        System.out.println(op) ;
        System.exit(0) ;
    }
    
    private static void query(String str, Dataset dataset)
    {
        query(str, dataset, null) ;
    }
    
    private static void query(String str, Dataset dataset, QuerySolution qs)
    {
        System.out.println(str) ; 
        Query q = QueryFactory.create(str, Syntax.syntaxARQ) ;
        QueryExecution qexec = QueryExecutionFactory.create(q, dataset, qs) ;
        ResultSet rs = qexec.execSelect() ;
        ResultSetFormatter.out(rs) ;
        qexec.close() ;
    }
    
    private static void query(String str, Model model)
    {
        Query q = QueryFactory.create(str, Syntax.syntaxARQ) ;
        QueryExecution qexec = QueryExecutionFactory.create(q, model) ;
        ResultSet rs = qexec.execSelect() ;
        ResultSetFormatter.out(rs) ;
        qexec.close() ;
    }
    
    private static void test()
    {
        String testNum = "2" ;
        String dir = "testing/UnionGraph/" ;
        List<String> dftGraphs = Arrays.asList(dir+"data-dft.ttl") ;
        List<String> namedGraphs = Arrays.asList(dir+"data-1.ttl", dir+"data-2.ttl") ;
        String queryFile = dir+"merge-"+testNum+".rq" ;
        ResultSet rs = ResultSetFactory.load(dir+"merge-"+testNum+"-results.srx") ;
        
        TestCase t = new QueryTestTDB("Test", null, "uri", dftGraphs, namedGraphs, rs, queryFile, TDBMaker.memFactory) ;
        JUnitCore runner = new org.junit.runner.JUnitCore() ;
        runner.addListener(new TextListener2(System.out)) ;
        
        TC_TDB.beforeClass() ;
        Result result = runner.run(t) ;
        TC_TDB.afterClass() ;
    }
    
    
    
    private static void tdbquery(String... args)
    {
        tdb.tdbquery.main(args) ;
        System.exit(0) ;
    }
    
    private static void tdbloader(String... args)
    {
        tdb.tdbloader.main(args) ; 
        System.exit(0) ;
    }
    
    private static void tdbdump(String... args)
    {
        tdb.tdbdump.main(args) ; 
        System.exit(0) ;
    }
    
    private static void tdbtest(String...args)
    {
        tdb.tdbtest.main(args) ;
        System.exit(0) ;
    }
    
    private static void tdbconfig(String... args) 
    {
        tdb.tdbconfig.main(args) ;
        System.exit(0) ;
    }
}

/*
 * (c) Copyright 2007, 2008, 2009 Hewlett-Packard Development Company, LP
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */