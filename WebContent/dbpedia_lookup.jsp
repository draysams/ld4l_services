<%@ page language="java" contentType="application/n-triples; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sparql" uri="http://slis.uiowa.edu/SPARQL"%>

<sparql:setEndpoint var="ld4l" sparqlURL="http://services.ld4l.org/fuseki/dbpedia/sparql">
	<sparql:prefix prefix="foaf" baseURI="http://xmlns.com/foaf/0.1/" />
	<sparql:prefix prefix="bibo" baseURI="http://purl.org/ontology/bibo/" />
	<sparql:prefix prefix="rdf"	baseURI="http://www.w3.org/1999/02/22-rdf-syntax-ns#" />
	<sparql:prefix prefix="rdfs" baseURI="http://www.w3.org/2000/01/rdf-schema#" />
	<sparql:prefix prefix="vivo" baseURI="http://vivoweb.org/ontology/core#" />
</sparql:setEndpoint>

<sparql:query var="entity" endpoint="${ld4l}" resultType="triple">
    SELECT DISTINCT ?p ?o WHERE {
        ?s ?p ?o
    }
    <sparql:parameter var="s" value="${param.uri}" type="IRI" />
</sparql:query>

<c:forEach items="${entity.rows}" var="row" varStatus="rowCounter">
${param.uri} ${row.p} ${row.o} .
</c:forEach>
