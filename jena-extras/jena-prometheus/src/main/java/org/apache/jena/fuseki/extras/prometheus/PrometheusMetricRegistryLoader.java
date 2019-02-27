/*
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
package org.apache.jena.fuseki.extras.prometheus;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Tags;
import io.micrometer.core.instrument.binder.jvm.ClassLoaderMetrics;
import io.micrometer.core.instrument.binder.jvm.DiskSpaceMetrics;
import io.micrometer.core.instrument.binder.jvm.JvmGcMetrics;
import io.micrometer.core.instrument.binder.jvm.JvmMemoryMetrics;
import io.micrometer.core.instrument.binder.jvm.JvmThreadMetrics;
import io.micrometer.core.instrument.binder.system.FileDescriptorMetrics;
import io.micrometer.core.instrument.binder.system.ProcessorMetrics;
import io.micrometer.core.instrument.binder.system.UptimeMetrics;
import io.micrometer.prometheus.PrometheusConfig;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import java.io.File;
import org.apache.jena.fuseki.metrics.MetricRegistryLoader;

public class PrometheusMetricRegistryLoader implements MetricRegistryLoader {

    @Override
    public MeterRegistry load() {
        MeterRegistry result = new PrometheusMeterRegistry( PrometheusConfig.DEFAULT );

        new FileDescriptorMetrics().bindTo( result );
        new ProcessorMetrics().bindTo( result );
        new ClassLoaderMetrics().bindTo( result );
        new UptimeMetrics().bindTo( result );
        for (File root : File.listRoots()) {
            new DiskSpaceMetrics(root, Tags.of("root", root.getName())).bindTo( result );
        }
        new JvmGcMetrics().bindTo( result );
        new JvmMemoryMetrics().bindTo( result );
        new JvmThreadMetrics().bindTo( result );

        return result;
    }

    @Override
    public int getPriority() {
        return 1;
    }
}
