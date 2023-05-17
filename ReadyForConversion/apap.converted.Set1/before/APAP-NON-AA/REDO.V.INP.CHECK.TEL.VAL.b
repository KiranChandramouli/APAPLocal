*----------------------------------------------------------------------------
* <Rating>-35</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.CHECK.TEL.VAL
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :JANANI
*Program   Name    :REDO.V.INP.CHECK.TEL.VAL
*----------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*----------------------------------------------------------------------
*DESCRIPTION       :This program is used to validate the telephone fields
*
*LINKED WITH       : CUSTOMER,TEL.CHECK
* ----------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*25.11.2009      JANANI           ODR-2009-10-0530    INITIAL CREATION
*12.05.2010    SUDHARSANAN S         HD1018074      MODIFICATION AS PER THE ISSUE
*-----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.COUNTRY

  GOSUB INIT
  GOSUB OPENFILE
  GOSUB LOCAL.REF.INIT
  GOSUB CHECK
  GOSUB LEN.CHECK
  GOSUB CONT.MAND

  RETURN

************
INIT:
************
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER=''
  FN.COUNTRY = 'F.COUNTRY'
  F.COUNTRY=''
  R.COUNTRY=''

  READ.ERR=''

  Y.LOC.POS=''
  ETEXT=''
  Y.VAL.POS=''
  TEL.TYPE=''
  TEL.NUM=''

  L.CU.TEL.TYPE.VAL.POS=''
  L.CU.TEL.AREA.VAL.POS=''
  L.CU.TEL.NO.VAL.POS=''
  L.CU.TEL.EXT.VAL.POS=''

  I.TEL.TYPE.VAL=''
  I.TEL.AREA.VAL=''
  I.TEL.NO.VAL=''
  I.TEL.EXT.VAL=''

  TEL.TYPE.VAL=''
  TEL.AREA.VAL=''
  TEL.NO.VAL=''
  TEL.EXT.VAL=''

  CUS.RES=''
  COU.TEL.AREA.VAL=''
  RETURN

***********
OPENFILE:
***********
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  CALL OPF(FN.COUNTRY,F.COUNTRY)
  RETURN

*******************************
LOCAL.REF.INIT:
***********

  Y.LOC.FLDS="L.CU.TEL.TYPE":VM:"L.CU.TEL.AREA":VM:"L.CU.TEL.NO":VM:"L.CU.TEL.EXT":VM:"L.CU.TIPO.CL":VM:"L.CU.TEL.P.CONT":FM:"L.COU.TEL.AREA"
  APPLICATION.NAMES = "CUSTOMER":FM:"COUNTRY"

  CALL MULTI.GET.LOC.REF(APPLICATION.NAMES,Y.LOC.FLDS,Y.LOC.POS)
  L.CU.TEL.TYPE.VAL.POS=Y.LOC.POS<1,1>
  L.CU.TEL.AREA.VAL.POS=Y.LOC.POS<1,2>
  L.CU.TEL.NO.VAL.POS=Y.LOC.POS<1,3>
  L.CU.TEL.EXT.VAL.POS=Y.LOC.POS<1,4>
  TIPO.CL.POS = Y.LOC.POS<1,5>
  TEL.P.CONT.POS =Y.LOC.POS<1,6>
  L.COUNTRY.AREA.POS = Y.LOC.POS<2,1>

  CUS.RES=R.NEW(EB.CUS.RESIDENCE)

  TEL.TYPE.VAL=R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.TEL.TYPE.VAL.POS>
  TEL.AREA.VAL=R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.TEL.AREA.VAL.POS>
  TEL.NO.VAL=R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.TEL.NO.VAL.POS>
  TEL.EXT.VAL=R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.TEL.EXT.VAL.POS>
  TIPO.CL.VAL=R.NEW(EB.CUS.LOCAL.REF)<1,TIPO.CL.POS>
  TEL.P.CONT.VAL=R.NEW(EB.CUS.LOCAL.REF)<1,TEL.P.CONT.POS>
  VAR.CUSTOMER.TYPE = R.NEW(EB.CUS.CUSTOMER.TYPE)
  RETURN
************ CHECKS IF THE AREA MATCHES AREA IN COUNTRY TAB ********************
CHECK:
*******
  CALL F.READ(FN.COUNTRY,CUS.RES,R.COUNTRY,F.COUNTRY,READ.ERR)
  IF R.COUNTRY THEN
    COU.TEL.AREA.VAL=R.COUNTRY<EB.COU.LOCAL.REF,L.COUNTRY.AREA.POS>
  END

  CHANGE SM TO FM IN TEL.TYPE.VAL
  CHANGE SM TO FM IN TEL.AREA.VAL
  CHANGE SM TO FM IN TEL.NO.VAL
  CHANGE SM TO FM IN TEL.EXT.VAL
  CHANGE SM TO FM IN TEL.P.CONT.VAL

  AS.POS = 1
  I.COU.TEL.AREA.VAL=''
  LOOP

    REMOVE I.TEL.TYPE.VAL FROM TEL.TYPE.VAL SETTING POS
  WHILE I.TEL.TYPE.VAL:POS
    V.AREA.CODE=''
    I.TEL.AREA.VAL=TEL.AREA.VAL<AS.POS>

    LOCATE I.TEL.AREA.VAL IN COU.TEL.AREA.VAL<1,1,1> SETTING Y.POS THEN
      V.AREA.CODE = COU.TEL.AREA.VAL<1,1,Y.POS>
    END
    IF V.AREA.CODE EQ '' THEN
      ETEXT = 'EB-INVALID.AREA.CODE'
      AF=EB.CUS.LOCAL.REF
      AV=L.CU.TEL.AREA.VAL.POS
      AS = AS.POS
      CALL STORE.END.ERROR

    END

    I.TEL.EXT.VAL = TEL.EXT.VAL<AS.POS>
    IF I.TEL.TYPE.VAL NE '5' THEN
      IF I.TEL.EXT.VAL NE '' THEN
        ETEXT = 'EB-NO.NOT.VALID'
        AF=EB.CUS.LOCAL.REF
        AV=L.CU.TEL.EXT.VAL.POS
        AS = AS.POS
        CALL STORE.END.ERROR
      END
    END
    AS.POS = AS.POS + 1
  REPEAT
  RETURN
********* CHECKS IF LENTH IS 7 IF RESIDENCE IS 'DO***************
LEN.CHECK:
*********

  IF CUS.RES EQ 'DO' THEN

    AS.POS = 1
    LOOP
      REMOVE I.TEL.NO.VAL FROM TEL.NO.VAL SETTING POS
    WHILE I.TEL.NO.VAL:POS
      IF LEN(I.TEL.NO.VAL) NE '7' THEN
        ETEXT = 'EB-NO.NOT.VALID'
        AF=EB.CUS.LOCAL.REF
        AV=L.CU.TEL.NO.VAL.POS
        AS=AS.POS
        CALL STORE.END.ERROR
      END
      AS.POS = AS.POS + 1
    REPEAT
  END
  RETURN
*************
CONT.MAND:
***************
* IF the field L.CU.TIPO.CL is PERSONA JURIDICA then L.CU.TEL.P.CONT is Mandatory
  IF TIPO.CL.VAL EQ 'PERSONA JURIDICA' AND VAR.CUSTOMER.TYPE EQ 'ACTIVE' THEN
    AS.POS=1
    TEL.P.CONT.VAL.COUNT=DCOUNT(TEL.P.CONT.VAL,FM)
    IF TEL.P.CONT.VAL.COUNT EQ 0 THEN
      AF=EB.CUS.LOCAL.REF
      AV=TEL.P.CONT.POS
      AS=AS.POS
      ETEXT='EB-TEL.P.CONT.MANDATORY':FM:TIPO.CL.VAL
      CALL STORE.END.ERROR
    END ELSE
      FOR TEL.P.CONT.VAL.CNT=1 TO TEL.P.CONT.VAL.COUNT
        Y.TEL.P.CONT.VAL=TEL.P.CONT.VAL<TEL.P.CONT.VAL.CNT>
        IF Y.TEL.P.CONT.VAL EQ '' THEN
          ETEXT='EB-TEL.P.CONT.MANDATORY':FM:TIPO.CL.VAL
          AF=EB.CUS.LOCAL.REF
          AV=TEL.P.CONT.POS
          AS=AS.POS
          CALL STORE.END.ERROR
        END
        AS.POS = AS.POS + 1
      NEXT TEL.P.CONT.VAL.CNT
    END
  END
  RETURN
*-----------------------------------------------------------------------
END
