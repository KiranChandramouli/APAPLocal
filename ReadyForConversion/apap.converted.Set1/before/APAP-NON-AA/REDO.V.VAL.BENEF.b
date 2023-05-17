*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.VAL.BENEF
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This is Validation routine for the field BENEFICIARY of TELLER to
* default in NARRATIVE
*
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
* Linked : TELLER
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.VAL.BENEF
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE WHO REFERENCE DESCRIPTION
* 16.03.2010 SUDHARSANAN S ODR-2009-10-0319 INITIAL CREATION
* -----------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER

GOSUB LOCAL.REF
GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
LOCAL.REF:
*-----------------------------------------------------------------------------
LOC.REF.APPLICATION="TELLER"
LOC.REF.FIELDS='L.TT.BENEFICIAR'
LOC.REF.POS=''
CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
POS.BENEFICIARY =LOC.REF.POS<1,1>
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
Y.BENEFICIARY.NAME=R.NEW(TT.TE.LOCAL.REF)<1,POS.BENEFICIARY>
IF Y.BENEFICIARY.NAME THEN
R.NEW(TT.TE.NARRATIVE.1)<1,1> = Y.BENEFICIARY.NAME
END
RETURN
END
