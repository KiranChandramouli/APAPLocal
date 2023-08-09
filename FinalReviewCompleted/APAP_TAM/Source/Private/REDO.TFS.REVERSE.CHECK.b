* @ValidationCode : MjotMTYwNzU0MTAzMTpDcDEyNTI6MTY5MDE3NjEwMTc0MzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 10:51:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TFS.REVERSE.CHECK
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*Description: This routine is to check whether the Clearing Outfile has been
*
*               processed for the TFS.
*DATE		 AUTHOR		           Modification                            DESCRIPTION
*13/07/2023	CONVERSION TOOL     AUTO R22 CODE CONVERSION		        VM TO @VM, "++" TO "+=1"
*13/07/2023	 VIGNESHWARI	   MANUAL R22 CODE CONVERSION		             NOCHANGE
*-----------------------------------------------------------------------------------------------------------------------------------
*------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.OUT.CLEAR.FILE
    $INSERT I_F.T24.FUND.SERVICES
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
    WHILE Y.REV.INT LE Y.REV.TOTAL
        R.NEW(TFS.REVERSAL.MARK)<1,Y.REV.INT> = 'R'
        Y.REV.INT += 1
    REPEAT
    CALL F.READ(FN.REDO.OUT.CLEAR.FILE,Y.TODAY,R.REDO.OUT.CLEAR.FILE,F.REDO.OUT.CLEAR.FILE,OUT.ERR)
    LOCATE Y.ID IN R.REDO.OUT.CLEAR.FILE<REDO.OUT.CLEAR.FILE.TFS.ID,1> SETTING POS THEN
        ETEXT = 'EB-REDO.REV.NOT.ALLOWED'
        CALL STORE.END.ERROR
    END
RETURN
END
