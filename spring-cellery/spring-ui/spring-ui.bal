//   Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

// Cell file for Pet Store Sample Frontend.
// This Cell encompasses the component which exposes the Pet Store portal

import celleryio/cellery;
import ballerina/config;

public function build(cellery:ImageName iName) returns error? {
    // Portal Component
    // This is the Component which exposes the Pet Store portal
    cellery:Component uiComponent = {
        name: "ui",
        source: {
            image: "athukorala/spring-ui"
        },
        ingresses: {
            portal: <cellery:WebIngress>{ // Web ingress will be always exposed globally.
                port: 8098,
                gatewayConfig: {
                    vhost: "cellery-demo.com",
                    context: "/",
                    oidc: {
                        nonSecurePaths: ["/", "/app/*"],
                        providerUrl: "",
                        clientId: "",
                        clientSecret: {
                            dcrUser: "",
                            dcrPassword: ""
                        },
                        redirectUrl: "http://cellery-demo.com/_auth/callback",
                        baseUrl: "http://cellery-demo.com/",
                        subjectClaim: "given_name"
                    }
                }
            }
        },
        envVars: {
            ARTICLE_URL: { value: "" },
            AUTHOR_URL: { value: "" }
        },
        dependencies: {
            cells: {
                article: <cellery:ImageName>{ org: "athukorala", name: "spring-art", ver: "latest" },
                author: <cellery:ImageName>{ org: "athukorala", name: "spring-auth", ver: "latest" }
            }
        }
    };

    // Assign the URL of the articles cell
    uiComponent.envVars.ARTICLE_URL.value =
    <string>cellery:getReference(uiComponent, "article").controller_api_url;

    // Assign the URL of the authors cell
    uiComponent.envVars.AUTHOR_URL.value =
        <string>cellery:getReference(uiComponent, "author").controller_api_url;

    // Cell Initialization
    cellery:CellImage uiCell = {
        components: {
            ui: uiComponent
        }
    };
    return cellery:createImage(uiCell, untaint iName);
}

public function run(cellery:ImageName iName, map<cellery:ImageName> instances) returns error? {
    cellery:CellImage uiCell = check cellery:constructCellImage(untaint iName);
    cellery:Component uiComponent = uiCell.components.ui;
    string vhostName = config:getAsString("VHOST_NAME");
    if (vhostName !== "") {
        cellery:WebIngress web = <cellery:WebIngress>uiComponent.ingresses.portal;
        web.gatewayConfig.vhost = vhostName;
        web.gatewayConfig.oidc.redirectUrl = "http://" + vhostName + "/_auth/callback";
        web.gatewayConfig.oidc.baseUrl = "http://" + vhostName + "/";
    }

    cellery:WebIngress uiIngress = <cellery:WebIngress>uiComponent.ingresses.portal;
    uiIngress.gatewayConfig.oidc.providerUrl = config:getAsString("providerUrl", defaultValue =
        "https://idp.cellery-system/oauth2/token");
    uiIngress.gatewayConfig.oidc.clientId = config:getAsString("clientId", defaultValue = "sampleapplication");
    cellery:DCR dcrConfig = {
        dcrUser: config:getAsString("dcrUser", defaultValue = "admin"),
        dcrPassword: config:getAsString("dcrPassword", defaultValue = "admin")
    };
    uiIngress.gatewayConfig.oidc.clientSecret = dcrConfig;

    return cellery:createInstance(uiCell, iName, instances);
}

