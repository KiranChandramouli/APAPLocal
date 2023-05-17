SUBROUTINE REDO.S.COL.A.TSA.RECORD
*------------------------------------------------------------------------------------------------------------------
* Developer    : jvalarezoulloa@temenos.com
* Date         : 2012-04-16
* Description  : Store comments in history Local fields
* Input/Output:
* -------------
* In  :
*
* Out :
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
*
*------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TSA.SERVICE

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------------------
    R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,1>> = R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,1>> : @SM : R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,3>>        ;*COL.INPUTTER.HIS
    R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,2>> = R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,2>> : @SM : R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,4>>        ;*COL.COMMENTS.HIS
    R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,3>> = ''          ;*COL.INPUTTER
    R.NEW(TS.TSM.LOCAL.REF)<1,LOC.REF.POS<1,4>>  = ''         ;*COL.COMMENTS
RETURN

*------------------------------------------------------------------------------------------------------------------
GET.LOCAL.FIELD:
*------------------------------------------------------------------------------------------------------------------

    L.FLD<1,1> = "COL.INPUT.HIS"
    L.FLD<1,2> = "COL.COMM.HIS"
    L.FLD<1,3> = "COL.INPUTTER"
    L.FLD<1,4> = "COL.COMMENTS"
    LOC.REF.APPLICATION = 'TSA.SERVICE'
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,L.FLD,LOC.REF.POS)

RETURN
*------------------------------------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------------------------------------
    L.FLD = ''
    TXN.REF.ID.POS=''
    LOC.REF.POS = ''
    GOSUB GET.LOCAL.FIELD
    FN.TSA.SERVICE = 'F.TSA.SERVICE'
    F.TSA.SERVICE = ''
    R.TSA.SERVICE = ''
    YERR = ''
RETURN
*------------------------------------------------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------------------------------------------------
    CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)

RETURN
*------------------------------------------------------------------------------------------------------------------
END
