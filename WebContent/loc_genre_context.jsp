<%@ page language="java" contentType="application/n-triples; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sparql" uri="http://slis.uiowa.edu/SPARQL"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<sparql:setEndpoint var="ld4l" sparqlURL="http://services.ld4l.org/fuseki/loc_genre/sparql">
    <sparql:prefix prefix="foaf" baseURI="http://xmlns.com/foaf/0.1/"/>
    <sparql:prefix prefix="bibo" baseURI="http://purl.org/ontology/bibo/"/>
    <sparql:prefix prefix="rdf"  baseURI="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
    <sparql:prefix prefix="rdfs" baseURI="http://www.w3.org/2000/01/rdf-schema#"/>
    <sparql:prefix prefix="schema" baseURI="http://schema.org/"/>
    <sparql:prefix prefix="mads" baseURI="http://www.loc.gov/mads/rdf/v1#"/>
</sparql:setEndpoint>

<sparql:query var="result" endpoint="${ld4l}" resultType="triple">
    SELECT ?sn ?p ?o WHERE {
        {
            ?s ?p ?o .
            BIND(?s as ?sn)
        }
    UNION
        {
            ?s <http://www.w3.org/2004/02/skos/core#broader> ?sn .
            ?sn ?p ?o.
        }
    UNION
        {
            ?s <http://www.w3.org/2004/02/skos/core#narrower> ?sn .
            ?sn ?p ?o.
        }
    }
	<sparql:parameter var="s" value="${param.uri}" type="IRI" />
 </sparql:query>

<c:forEach items="${result.rows}" var="row" varStatus="rowCounter">
${row.sn} ${row.p} ${row.o} .
</c:forEach>