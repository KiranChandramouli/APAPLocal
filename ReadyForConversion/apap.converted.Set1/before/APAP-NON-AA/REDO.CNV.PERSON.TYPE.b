*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CNV.PERSON.TYPE
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* conversion to routine to get the PERSON.TYPE
*------------------------------------------------------------------------------------------------------
*APPLICATION
* attched as conversion routine for the enquiry REDO.E.SEC.TRADE
*-------------------------------------------------------------------------------------------------------

*
* Input / Output
* --------------
* IN     : Y.ENQ.OUT
* OUT    : Y.ENQ.OUT
*
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.CNV.PERSON.TYPE
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO         REFERENCE         DESCRIPTION
*23.08.2010      Janani     ODR-2011-02-0009 INITIAL CREATION
*
* ----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_ENQUIRY.COMMON

  GOSUB INIT
  GOSUB PROCESS
  RETURN

*------------------------------------------------------------
INIT:
*------------------------------------------------------------
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  R.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  LF.APP = 'CUSTOMER'
  LF.FLD = 'L.CU.TIPO.CL':VM:'L.CU.CIDENT'
  LF.POS = ''

  CALL MULTI.GET.LOC.REF(LF.APP,LF.FLD,LF.POS)
  L.CU.TIPO.CL.POS = LF.POS<1,1>
  L.CU.CIDENT.POS = LF.POS<1,2>
  RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

  CALL F.READ(FN.CUSTOMER,O.DATA,R.CUSTOMER,F.CUSTOMER,READ.ERR)
  L.CU.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
  L.CU.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
  NATIONALITY = R.CUSTOMER<EB.CUS.NATIONALITY>

  BEGIN CASE
  CASE L.CU.TIPO.CL EQ "PERSONA FISICA" AND NATIONALITY EQ "DO" AND L.CU.CIDENT NE ""
    O.DATA = "P1"
  CASE L.CU.TIPO.CL EQ "PERSONA FISICA" AND NATIONALITY NE "DO"
    O.DATA = "P2"
  CASE L.CU.TIPO.CL EQ "PERSONA FISICA" AND NATIONALITY EQ "DO" AND L.CU.CIDENT EQ ""
    O.DATA = "P3"
  CASE L.CU.TIPO.CL EQ "PERSONA JURIDICA"
    O.DATA = "E1"
  CASE 1
    O.DATA = ""
  END CASE

  RETURN
*------------------------------------------------------------
END
