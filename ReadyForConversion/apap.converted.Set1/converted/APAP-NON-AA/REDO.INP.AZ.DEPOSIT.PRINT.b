SUBROUTINE REDO.INP.AZ.DEPOSIT.PRINT
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed to accept all overrides for deal slip generation
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.CHK.AZ.DEPOSIT.PRINT
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE         WHO                 REFERENCE       DESCRIPTION
* 08-11-2011   Sudharsanan S       CR.18           Initial Creation
* 04-04-2013   Vignesh Kumaar R    PACS00261598    To suppress the dealslip during Validation
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_RC.COMMON

* Fix for PACS00261598 [To suppress the dealslip during Validation]

    IF OFS$OPERATION EQ 'PROCESS' THEN

* End
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------

    FN.DEP.REPRINT = 'F.REDO.DEP.REPRINT.DETAILS'
    F.DEP.REPRINT  = ''
    CALL OPF(FN.DEP.REPRINT,F.DEP.REPRINT)

    BEGIN CASE
        CASE PGM.VERSION EQ ",REDO.OPEN.SMB.CF.PRINT"
            DEAL.SLIP.ID = "REDO.CF.DETAIL"

        CASE PGM.VERSION EQ ",REDO.OPEN.SMB.CF.RED.PRINT"
            DEAL.SLIP.ID = "REDO.CF.RD.DET"

        CASE PGM.VERSION EQ ",REDO.OPEN.CPH.PRINT"
            DEAL.SLIP.ID = "REDO.CPH.DETAIL"

        CASE PGM.VERSION EQ ",REDO.OPEN.SMB.DP.PRINT"
            DEAL.SLIP.ID = "REDO.DP.DETAIL"

    END CASE

    OFS$DEAL.SLIP.PRINTING = 1
    CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.ID)
    Y.DEAL.SLIP.HOLD.ID = C$LAST.HOLD.ID
    VAR.AZ.ID = ID.NEW
    IF Y.DEAL.SLIP.HOLD.ID THEN
        CALL F.WRITE(FN.DEP.REPRINT,VAR.AZ.ID,Y.DEAL.SLIP.HOLD.ID)
    END

    OFS$OVERRIDES = ''
RETURN
*---------------------------------------------------------------------------------------------------------------
END
