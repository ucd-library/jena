/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.jena.fuseki.ctl;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.ServiceLoader;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;
import org.apache.jena.fuseki.servlets.HttpAction;
import org.apache.jena.fuseki.servlets.ServletOps;

public class ActionExtras extends ActionCtl {

    Map<String,ExtraAction> actions = new HashMap<>();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init( config );

        ServiceLoader<ExtraAction> extraActionLoader = ServiceLoader.load( ExtraAction.class );
        for (ExtraAction extraAction : extraActionLoader) {
            extraAction.init( config );
            actions.put(extraAction.getPath(), extraAction);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long id = allocRequestId(req, resp);

        HttpAction action = allocHttpAction(id, req, resp) ;
        try {
            perform( action );
        } finally {
            action.setFinishTime() ;
            finishRequest(action);
        }
    }

    @Override
    protected void perform(HttpAction action) {
        String key = StringUtils.substringAfter(action.getActionURI(), "/$/extras/");
        if (actions.containsKey( key ) ) {
            actions.get( key ).perform( action );
        }
        else {
            try {
                action.response.sendError( 404 );
            }
            catch (IOException e) {
                ServletOps.errorOccurred(e) ;
            }
        }
    }
}
