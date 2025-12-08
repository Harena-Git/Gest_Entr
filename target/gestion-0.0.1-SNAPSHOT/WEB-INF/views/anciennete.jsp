<table>
  <tr>
    <th>ID</th>
    <th>Nom</th>
    <th>Poste</th>
    <th>Département</th>
    <th>Ancienneté (ans)</th>
  </tr>
  <c:forEach var="a" items="${anciennetes}">
    <tr>
      <td>${a.idPersonnel}</td>
      <td>${a.nomPersonnel}</td>
      <td>${a.poste}</td>
      <td>${a.departement}</td>
      <td>${a.anneeAnciennete}</td>
    </tr>
  </c:forEach>
</table>
