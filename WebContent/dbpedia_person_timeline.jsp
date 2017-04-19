<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sparql" uri="http://slis.uiowa.edu/SPARQL"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LD4L DBpedia Reconciliation Services</title>
<style type="text/css" media="all">    @import "/ld4l_services/resources/style.css";</style>
</head>
<body>
<div id="content"><jsp:include page="/header.jsp" flush="true" />
<jsp:include page="/menu.jsp" flush="true">
    <jsp:param name="caller" value="research" />
</jsp:include>
<div id="centerCol">
<h2>DBpedia Person: ${param.givenname} ${param.surname}</h2>

<sparql:setEndpoint var="ld4l" sparqlURL="http://guardian.slis.uiowa.edu:3030/dbpedia/sparql">
    <sparql:prefix prefix="foaf" baseURI="http://xmlns.com/foaf/0.1/"/>
    <sparql:prefix prefix="bibo" baseURI="http://purl.org/ontology/bibo/"/>
    <sparql:prefix prefix="rdf"  baseURI="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
    <sparql:prefix prefix="rdfs" baseURI="http://www.w3.org/2000/01/rdf-schema#"/>
    <sparql:prefix prefix="vivo" baseURI="http://vivoweb.org/ontology/core#"/>
    <sparql:prefix prefix="dbp" baseURI="http://dbpedia.org/property/"/>
    <sparql:prefix prefix="dbo" baseURI="http://dbpedia.org/ontology/"/>
</sparql:setEndpoint>

<sparql:query var="result" endpoint="${ld4l}" resultType="${mode}">
    <c:choose>
    <c:when test="${ not empty param.givenname and empty param.surname }">
	    SELECT ?s ?b ?d ?as ?ae WHERE {
	        ?s rdf:type foaf:Person.
	        ?s foaf:givenName ?givenname@en .
            OPTIONAL { ?s dbp:birthDate ?b } .
            OPTIONAL { ?s dbp:deathDate ?d } .
            OPTIONAL { ?s dbo:activeYearsStartYear ?as } .
            OPTIONAL { ?s dbo:activeYearsEndYear ?ae } .
	    }
        <sparql:parameter var="givenname" value="${param.givenname}"/>
    </c:when>
    <c:when test="${ empty param.givenname and not empty param.surname }">
        SELECT ?s ?b ?d ?as ?ae WHERE {
            ?s rdf:type foaf:Person.
            ?s foaf:surname ?surname@en .
            OPTIONAL { ?s dbp:birthDate ?b } .
            OPTIONAL { ?s dbp:deathDate ?d } .
            OPTIONAL { ?s dbo:activeYearsStartYear ?as } .
            OPTIONAL { ?s dbo:activeYearsEndYear ?ae } .
        }
        <sparql:parameter var="surname" value="${param.surname}"/>
    </c:when>
    <c:when test="${ not empty param.givenname and not empty param.surname }">
        SELECT DISTINCT ?s ?b ?d ?as ?ae WHERE {
            {
                ?s rdf:type foaf:Person .
                ?s foaf:name ?name@en .
                OPTIONAL { ?s dbp:birthDate ?b } .
                OPTIONAL { ?s dbp:deathDate ?d } .
                OPTIONAL { ?s dbo:activeYearsStartYear ?as } .
                OPTIONAL { ?s dbo:activeYearsEndYear ?ae } .
            }
        UNION
            {
                ?s rdf:type foaf:Person .
                ?s foaf:name ?sortname@en .
                OPTIONAL { ?s dbp:birthDate ?b } .
                OPTIONAL { ?s dbp:deathDate ?d } .
                OPTIONAL { ?s dbo:activeYearsStartYear ?as } .
                OPTIONAL { ?s dbo:activeYearsEndYear ?ae } .
            } 
        UNION
            {
                ?s rdf:type foaf:Person .
                ?s foaf:givenName ?givenname@en .
                ?s foaf:surname ?surname@en .
                OPTIONAL { ?s dbp:birthDate ?b } .
                OPTIONAL { ?s dbp:deathDate ?d } .
                OPTIONAL { ?s dbo:activeYearsStartYear ?as } .
                OPTIONAL { ?s dbo:activeYearsEndYear ?ae } .
            }
        }
        <sparql:parameter var="givenname" value="${param.givenname}"/>
        <sparql:parameter var="surname" value="${param.surname}"/>
        <sparql:parameter var="name" value="${param.givenname} ${param.surname}"/>
        <sparql:parameter var="sortname" value="${param.surname}, ${param.givenname}"/>
    </c:when>
    </c:choose>
 </sparql:query>

        <table border=1>
        <thead><tr><td>Subject</td><td>Birth Date</td><td>Death Date</td><td>Active Start</td><td>Active End</td></tr></thead>
        <tbody>
        <c:forEach items="${result.rows}" var="row" varStatus="rowCounter">
            <tr><td><a href="/ld4l_services/dbpedia_person_doi_browse.jsp?doi=${row.s}">${row.s}</a></td><td>${row.b}</td><td>${row.d}</td><td>${row.as}</td><td>${row.ae}</td></tr>
        </c:forEach>
        </tbody>
        </table>

<jsp:include page="/footer.jsp" flush="true" />
</div>
</div>
</body>
</html>
