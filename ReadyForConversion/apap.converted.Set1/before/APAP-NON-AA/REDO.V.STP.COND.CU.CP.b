*-----------------------------------------------------------------------------
* <Rating>-47</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.STP.COND.CU.CP(NO.OF.AUTH.FLAG)
*****************************************************************************************************************
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : NARESH.CHAVADAPU(nareshc@temenos.com)
*Date              : 28-10-2009
*Program   Name    : REDO.V.STP.COND.CU.CP
*Reference Number  : ODR-2009-10-0807
*-----------------------------------------------------------------------------------------------------------------
*Description    : This routine serves as a STP CONDITION routine for authorising the customer record when
* one of the following conditions meet
* 1.  A value change of CUSTOMER.TYPE field from PROSPECT to ACTIVE
* 2.  A value change of the local reference field L.CU.TIPO.CL from CLIENTE MENOR to PERSONA FISICA
* 3.  A value change on the local reference fields, L.CU.CIDENT, L.CU.NOUNICO, L.CU.RNC, L.CU.ACTANAC or LEGAL.ID fields
* 4.  A value change on the fields GIVEN.NAMES, FAMILY.NAME, NAME.1, NAME.2 and BIRTH.DATE fields
* 5.  A value change in the field RELATION.CODE field from 13 to any value or no value it's respective customer from the field REL.CUSTOMER field
*-----------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
* 29/10/2009           R.Ganesh               ODR-2009-10-0807         Initial Version
* 13/01/2011         J.Riyas Ahamad Basha       HD1053411              MODIFY (LINE: 127 AND 134)
* 11/07/2011         S.Sudharsanan                B.70                 Modify the code as per STP logic
*--------------------------------------------------------------------------------------------------------------------------
*Linked With : STP Condition
*In  Parameter     : NA
*Out Parameter     : NA
*--------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER

  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN
*-----
INIT:
*-----
  LOC.REF.APPLICATION="CUSTOMER"
  LOC.REF.FIELDS = "L.CU.TIPO.CL":VM:"L.CU.CIDENT":VM:"L.CU.NOUNICO":VM:"L.CU.RNC":VM:"L.CU.ACTANAC"
  LOC.REF.POS = ""
  NO.OF.AUTH.FLAG=1
  RETURN

*-----------
OPEN.FILES:
*-----------
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*------------------------------------------------------------------
* A value change of CUSTOMER.TYPE field from PROSPECT to ACTIVE
*------------------------------------------------------------------
  RETURN
*---------
PROCESS:
*---------

  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  FIELD.POS1 = LOC.REF.POS<1,1>
  FIELD.POS2 = LOC.REF.POS<1,2>
  FIELD.POS3 = LOC.REF.POS<1,3>
  FIELD.POS4 = LOC.REF.POS<1,4>
  FIELD.POS5 = LOC.REF.POS<1,5>
  Y.CUS.NEW=R.NEW(EB.CUS.CUSTOMER.TYPE)
  Y.CUS.OLD=R.OLD(EB.CUS.CUSTOMER.TYPE)
  IF (Y.CUS.NEW EQ 'ACTIVE' AND Y.CUS.OLD EQ 'PROSPECT') THEN
    NO.OF.AUTH.FLAG = '0'
  END
*------------------------------------------------
*checking value change of the field l.cu.tipo.cl
*------------------------------------------------

  Y.TIPO.NEW=R.NEW(EB.CUS.LOCAL.REF)<1,FIELD.POS1>
  Y.TIPO.OLD=R.OLD(EB.CUS.LOCAL.REF)<1,FIELD.POS1>
  IF (Y.TIPO.NEW  EQ 'PERSONA FISICA' AND Y.TIPO.OLD EQ 'CLIENTE MENOR') THEN
    NO.OF.AUTH.FLAG='0'
  END
*--------------------------------------
*checking value change of  l.cu.cident
*--------------------------------------
  Y.CIDENT.NEW=R.NEW(EB.CUS.LOCAL.REF)<1,FIELD.POS2>
  Y.CIDENT.OLD=R.OLD(EB.CUS.LOCAL.REF)<1,FIELD.POS2>
  IF Y.CIDENT.NEW NE Y.CIDENT.OLD THEN
    NO.OF.AUTH.FLAG='0'
  END
  Y.DATE.OF.BIRTH.OLD=R.OLD(EB.CUS.DATE.OF.BIRTH)
  Y.DATE.OF.BIRTH.NEW=R.NEW(EB.CUS.DATE.OF.BIRTH)
  IF Y.DATE.OF.BIRTH.OLD NE Y.DATE.OF.BIRTH.NEW THEN
    NO.OF.AUTH.FLAG='0'
  END
*--------------------------------------
* checking value change of l.cu.nounico
*--------------------------------------
  Y.NOUNICO.NEW=R.NEW(EB.CUS.LOCAL.REF)<1,FIELD.POS3>
  Y.NOUNICO.OLD=R.OLD(EB.CUS.LOCAL.REF)<1,FIELD.POS3>
  IF Y.NOUNICO.NEW NE Y.NOUNICO.OLD THEN
    NO.OF.AUTH.FLAG='0'
  END
  Y.CU.ACTANAC.NEW=R.NEW(EB.CUS.LOCAL.REF)<1,FIELD.POS5>
  Y.CU.ACTANAC.OLD=R.OLD(EB.CUS.LOCAL.REF)<1,FIELD.POS5>
  Y.GIVEN.NAMES.NEW=R.NEW(EB.CUS.GIVEN.NAMES)
  Y.GIVEN.NAMES.OLD=R.OLD(EB.CUS.GIVEN.NAMES)
  Y.FAMILY.NAME.NEW=R.NEW(EB.CUS.FAMILY.NAME)
  Y.FAMILY.NAME.OLD=R.OLD(EB.CUS.FAMILY.NAME)
  Y.NAME1.NEW = R.NEW(EB.CUS.NAME.1)
  Y.NAME1.OLD = R.OLD(EB.CUS.NAME.1)
  Y.NAME2.NEW = R.NEW(EB.CUS.NAME.2)
  Y.NAME2.OLD = R.OLD(EB.CUS.NAME.2)
  IF (Y.CU.ACTANAC.NEW NE Y.CU.ACTANAC.OLD) OR (Y.GIVEN.NAMES.NEW NE Y.GIVEN.NAMES.OLD) OR (Y.FAMILY.NAME.NEW NE Y.FAMILY.NAME.OLD) OR (Y.NAME1.NEW NE Y.NAME1.OLD) OR (Y.NAME2.NEW NE Y.NAME2.OLD) THEN
    NO.OF.AUTH.FLAG='0'
  END

*----------------------------------
* checking value change of l.cu.rnc
*----------------------------------
  Y.RNC.NEW=R.NEW(EB.CUS.LOCAL.REF)<1,FIELD.POS4>
  Y.RNC.OLD=R.OLD(EB.CUS.LOCAL.REF)<1,FIELD.POS4>
  IF Y.RNC.NEW NE Y.RNC.OLD THEN
    NO.OF.AUTH.FLAG='0'
  END
*-----------------------------------
* checking value change of legal.id
*-----------------------------------

  Y.LEGAL.ID.NEW=R.NEW(EB.CUS.LEGAL.ID)<1,1>
  Y.LEGAL.ID.OLD=R.OLD(EB.CUS.LEGAL.ID)<1,1>
  IF Y.LEGAL.ID.NEW NE Y.LEGAL.ID.OLD THEN
    NO.OF.AUTH.FLAG='0'
  END
*------------------------------------------------------------------------------------------
* extracting field values of the fields 'relation.code' and 'rel.customer' r.new and r.old
*-------------------------------------------------------------------------------------------

  Y.REL.COD.NEW=R.NEW(EB.CUS.RELATION.CODE)
  Y.REL.COD.OLD=R.OLD(EB.CUS.RELATION.CODE)
  Y.REL.CUS.NEW=R.NEW(EB.CUS.REL.CUSTOMER)
  Y.REL.CUS.OLD=R.OLD(EB.CUS.REL.CUSTOMER)

  LOCATE 13 IN Y.REL.COD.OLD<1,1> SETTING RELPOS.OLD THEN
    LOCATE 13 IN Y.REL.COD.NEW<1,1> SETTING RELPOS.NEW ELSE
      IF Y.REL.CUS.OLD<1,RELPOS.OLD> NE Y.REL.CUS.NEW<1,RELPOS.NEW> THEN
        NO.OF.AUTH.FLAG='0'
      END
    END
  END
  RETURN
END
