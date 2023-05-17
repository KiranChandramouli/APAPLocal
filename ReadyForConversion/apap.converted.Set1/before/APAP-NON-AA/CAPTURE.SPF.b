*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  PROGRAM CAPTURE.SPF

$INSERT I_COMMON
$INSERT I_EQUATE

  SEL.CMD = "LIST F.SPF"
  OPEN "TAM.BP" TO F.TAM THEN
    K = 1
  END

  EXECUTE SEL.CMD CAPTURING SEL.RET

  WRITE SEL.RET TO F.TAM,"CURRENT.SPF" ON ERROR
    K = -1
  END

END
