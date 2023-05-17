*-----------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.INSURANCE.SEQ.POL.NUM
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
* ====================================================================================
*
* Subroutine Type : Validation
* Attached to     : APAP.H.INSURANCE.DETAILS,REDO.INGRESO
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : pgarzongavilanes
* Date            : 2011-05-18
* Amended by      : ejijon@temenos.com
* Date            : 2011-10-26
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_System
$INSERT I_F.APAP.H.INSURANCE.DETAILS
$INSERT I_F.REDO.APAP.H.COMP.NAME

*
*************************************************************************
*


  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS

*
  RETURN
*
* ======
PROCESS:
* ======

*IF Y.CLASS.POLICY EQ "GROUP" OR  THEN
*CALL F.READU(FN.COMP.NAME, Y.COMP.NAME.ID, R.COMP.NAME, F.COMP.NAME, Y.ERR.COMP.NAME,P)
*CALL F.READU(FN.COMP.NAME, Y.COMP.NAME.ID, R.COMP.NAME, F.COMP.NAME, Y.ERR.COMP.NAME,0)
*CALL F.READ(FN.COMP.NAME, Y.COMP.NAME.ID, R.COMP.NAME, F.COMP.NAME, Y.ERR.COMP.NAME)

  READ R.COMP.NAME FROM F.COMP.NAME,Y.COMP.NAME.ID THEN 

    FIELDS.NO = DCOUNT(R.COMP.NAME<REDO.CMP.CLASS.POLICY>,VM)

    W.CLASS.POLICY = R.COMP.NAME<REDO.CMP.CLASS.POLICY>
    W.POLICY.TYPE = R.COMP.NAME<REDO.CMP.INS.POLICY.TYPE>

    FOR I=1 TO FIELDS.NO
      IF W.POLICY.TYPE<1,I> EQ Y.POLICY.TYPE AND W.CLASS.POLICY<1,I> EQ Y.CLASS.POLICY THEN
        Y.SEN.POLICY.NUMBER = R.COMP.NAME<REDO.CMP.SEN.POLICY.NUMBER,I>
        Y.MAX.SEN.POL.NUM = R.COMP.NAME<REDO.CMP.MAX.POLICY.NUMBER,I>
        R.COMP.NAME<REDO.CMP.MAX.POLICY.NUMBER,I> = Y.MAX.SEN.POL.NUM + 1
*CALL F.WRITE(FN.COMP.NAME, Y.COMP.NAME.ID, R.COMP.NAME)
        WRITE R.COMP.NAME TO F.COMP.NAME,Y.COMP.NAME.ID  
      END
    NEXT

    IF Y.MAX.SEN.POL.NUM EQ '' THEN
      Y.NEXT.SEN.POL.NUM = 1
    END ELSE
      Y.NEXT.SEN.POL.NUM = Y.MAX.SEN.POL.NUM + 1
    END

    W.NUM.CEROS = 6 - LEN(Y.NEXT.SEN.POL.NUM)
    FOR I = 1 TO W.NUM.CEROS
      W.CEROS = '0' : W.CEROS
    NEXT

    IF R.NEW(INS.DET.POLICY.NUMBER) EQ "" THEN
      R.NEW(INS.DET.SEN.POLICY.NUMBER) = Y.SEN.POLICY.NUMBER
      R.NEW(INS.DET.POLICY.NUMBER) = Y.SEN.POLICY.NUMBER : '-' : W.CEROS: Y.NEXT.SEN.POL.NUM
    END
  END

* esto es solo para actualizar el campo MONTO PRIMA TOTAL MENSUAL cuando ingresan por fabrica, ya que esta definido como campo NOINPUT
* y no pueden enviar el valor por OFS porque da un error

*   E = ""
*   Y.ARR.ID = System.getVariable("CURRENT.RCA")
*   IF E THEN
*      E = ""   19/06/2012 SJ.- comento este IF porque cuando es PVC no esta sumando el TOT.PRE.AMT desde FC
*      RETURN
*   END ELSE
  NO.OF.AMT = DCOUNT(R.NEW(INS.DET.MON.POL.AMT),VM)
  FOR ITR.POL=1 TO NO.OF.AMT
    R.NEW(INS.DET.MON.TOT.PRE.AMT)<1,ITR.POL> = R.NEW(INS.DET.MON.POL.AMT)<1,ITR.POL> + R.NEW(INS.DET.EXTRA.AMT)<1,ITR.POL>
  NEXT
*   END




  RETURN
*
* =========
OPEN.FILES:
* =========
*
  CALL OPF(FN.COMP.NAME, F.COMP.NAME)

  RETURN

*
* ======================
INITIALISE:
* ======================
*

  FN.COMP.NAME = 'F.REDO.APAP.H.COMP.NAME'
  F.COMP.NAME = ''
  R.COMP.NAME = ''
  Y.COMP.NAME.ID = R.NEW(INS.DET.INS.COMPANY)
  Y.ERR.COMP.NAME = ''

  Y.POLICY.TYPE = R.NEW(INS.DET.INS.POLICY.TYPE)
  Y.CLASS.POLICY = R.NEW(INS.DET.CLASS.POLICY)

  W.CEROS = ''
  W.NUM.CEROS = 0

  RETURN

END
