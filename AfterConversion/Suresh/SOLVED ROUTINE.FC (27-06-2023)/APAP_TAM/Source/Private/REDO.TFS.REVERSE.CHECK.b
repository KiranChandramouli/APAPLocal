* @ValidationCode : MjotNzU2NDU5OTc5OkNwMTI1MjoxNjg3ODQxMjE5NzQ5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Jun 2023 10:16:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.TFS.REVERSE.CHECK
*------------------------------------------------------------
*Description: This routine is to check whether the Clearing Outfile has been
*               processed for the TFS.
*------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*26/06/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION             NOCHANGE
*26/06/2023      SURESH                     MANUAL R22 CODE CONVERSION      VARIABLE NAME MODIFIED
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.OUT.CLEAR.FILE
*   $INSERT I_F.T24.FUND.SERVICES     ;*R22 MANUAL CODE CONVERSION
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------
    FN.REDO.OUT.CLEAR.FILE = 'F.REDO.OUT.CLEAR.FILE'
    F.REDO.OUT.CLEAR.FILE = ''
    CALL OPF(FN.REDO.OUT.CLEAR.FILE,F.REDO.OUT.CLEAR.FILE)

RETURN
*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

    Y.ID = ID.NEW
    Y.TODAY  = TODAY

    Y.REV.TOTAL =  DCOUNT(R.NEW(TFS.REVERSAL.MARK),@VM)
    LOOP
* WHILE Y.REV.INT LE Y.REV.TOTAL
        Y.REV.INT=""                ;*Because of commented 'I_F.T24.FUND.SERVICES' insert file,
        R.NEW(TFS.REVERSAL.MARK)<1,Y.REV.INT> = 'R'
        Y.REV.INT++
    REPEAT
    CALL F.READ(FN.REDO.OUT.CLEAR.FILE,Y.TODAY,R.REDO.OUT.CLEAR.FILE,F.REDO.OUT.CLEAR.FILE,OUT.ERR)
    LOCATE Y.ID IN R.REDO.OUT.CLEAR.FILE<REDO.OUT.CLEAR.FILE.TFS.ID,1> SETTING POS THEN
        ETEXT = 'EB-REDO.REV.NOT.ALLOWED'
        CALL STORE.END.ERROR
    END
RETURN
END
