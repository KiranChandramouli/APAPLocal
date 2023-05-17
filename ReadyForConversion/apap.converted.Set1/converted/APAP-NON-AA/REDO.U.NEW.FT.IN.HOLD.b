SUBROUTINE REDO.U.NEW.FT.IN.HOLD(ARR.ID,FT.ID,R.FUNDS.TRANSFER,R.STO)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the internal call routine triggered to create FT record in hold based on the incoming values
* and updates the concate files
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN :
* ARR.ID - Arrangement id
* FT.ID - @ID of the funds transfer record that need to be created in hold
* R.FUNDS.TRANSFER - FUNDS.TRANSFER record that needs to be put in hold
* R.STO - Standing order record
* OUT : - NA -
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
* Date who Reference Description
* 07-JUN-2010 N.Satheesh Kumar ODR-2009-10-0331 Initial Creation
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDING.ORDER

    $INSERT I_F.REDO.RESUBMIT.FT.DET
    $INSERT I_F.REDO.STO.PENDING.RESUBMISSION

    GOSUB OPEN.FILES
    GOSUB CREATE.FT.IN.HOLD
RETURN

*----------
OPEN.FILES:
*----------

    FN.REDO.STO.PENDING.RESUBMISSION = 'F.REDO.STO.PENDING.RESUBMISSION'
    F.REDO.STO.PENDING.RESUBMISSION = ''
    CALL OPF(FN.REDO.STO.PENDING.RESUBMISSION,F.REDO.STO.PENDING.RESUBMISSION)

    FN.REDO.RESUBMIT.FT.DET = 'F.REDO.RESUBMIT.FT.DET'
    F.REDO.RESUBMIT.FT.DET = ''
    CALL OPF(FN.REDO.RESUBMIT.FT.DET,F.REDO.RESUBMIT.FT.DET)

RETURN
*-----------------
CREATE.FT.IN.HOLD:
*-----------------
*---------------------------------------
* This section creates FT record in HOLD
*---------------------------------------

    STO.RETRY.DAYS.POS = ''
    CALL GET.LOC.REF('STANDING.ORDER','L.RETRY.DAYS',STO.RETRY.DAYS.POS)


    APP.NAME = 'FUNDS.TRANSFER'
    OFSFUNCT = 'I'
    PROCESS = 'PROCESS'
    OFSVERSION = 'FUNDS.TRANSFER,AA.LS.LC.ACRP'
    GTSMODE = 4
    NO.OF.AUTH = ''
    OFS.SOURCE.ID = 'REDO.OFS.STATUS.COND'

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,FT.ID,R.FUNDS.TRANSFER,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
    GOSUB UPDATE.RETRY.TABLE
RETURN

*------------------
UPDATE.RETRY.TABLE:
*------------------
*--------------------------------------------------------------------------------------
* This section updates the FT record in hold to REDO.STO.PENDING.RESUBMISSION for retry
*--------------------------------------------------------------------------------------
    END.DATE = TODAY

    R.REDO.STO.PENDING.RESUBMISSION = R.FUNDS.TRANSFER
    DAYS = R.STO<STO.LOCAL.REF,STO.RETRY.DAYS.POS>:'C'
    CALL CDT('',END.DATE,DAYS)
    R.REDO.STO.PENDING.RESUBMISSION<REDO.RESUB.END.DATE> = END.DATE
    CALL F.WRITE(FN.REDO.STO.PENDING.RESUBMISSION,FT.ID,R.REDO.STO.PENDING.RESUBMISSION)
    GOSUB UPDATE.CONCAT.FILE
RETURN

*------------------
UPDATE.CONCAT.FILE:
*------------------
*------------------------------------------------------------------------------------------------
* This section updates the concat file with bill id and FT date for the FT updated in RETRY TABLE
*------------------------------------------------------------------------------------------------

    CALL F.READ(FN.REDO.RESUBMIT.FT.DET,ARR.ID,R.REDO.RESUBMIT.FT.DET,F.REDO.RESUBMIT.FT.DET,FT.RESUB.ERR)
    IF R.REDO.RESUBMIT.FT.DET EQ '' THEN
        R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.FT.ID> = FT.ID
        R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.DATE> = TODAY
        R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.BILL.AMT> = R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
    END ELSE
        R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.FT.ID,-1> = FT.ID
        R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.DATE,-1> = TODAY
        R.REDO.RESUBMIT.FT.DET<REDO.RESUB.DET.BILL.AMT,-1> = R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
    END
    CALL F.WRITE(FN.REDO.RESUBMIT.FT.DET,ARR.ID,R.REDO.RESUBMIT.FT.DET)
RETURN
END
