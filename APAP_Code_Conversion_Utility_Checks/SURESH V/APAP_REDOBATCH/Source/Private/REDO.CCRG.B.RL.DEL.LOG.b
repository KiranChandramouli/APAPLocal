* @ValidationCode : MjotOTE4MjY5NjI2OkNwMTI1MjoxNjg0ODU0NDA2MjA2OklUU1M6LTE6LTE6MTY3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 167
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CCRG.B.RL.DEL.LOG(P.IN.CUS.ID)
*-----------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    vpanchi@temenos.com
* @stereotype subroutine: Routine
* @package:   REDO.CCRG
*!
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*  This routine insert the messages in REDO.CCRG.RL.LOG application
*
*  Input Param:
*  ------------
*  P.IN.CUS.ID:
*            Customer code to search
*  P.IN.ERR.MSG:
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*** <region name= INITIALISE>
***
INITIALISE:
    PROCESS.GOAHEAD = 1
    FN.REDO.CCRG.LOG = 'F.REDO.CCRG.RL.LOG'
    F.REDO.CCRG.LOG  = ''
    R.REDO.CCRG.LOG  = ''
RETURN
*** </region>

*** <region name= OPEN.FILES>
***
OPEN.FILES:
    CALL OPF(FN.REDO.CCRG.RL.LOG, F.REDO.CCRG.RL.LOG)
RETURN
*** </region>

*** <region name= PROCESS>
***
PROCESS:
    SELECT.STATEMENT = 'SELECT ':FN.REDO.CCRG.RL.LOG : ' WITH CUSTOMER.ID EQ ' : P.IN.CUS.ID
    CALL EB.READLIST(SELECT.STATEMENT,REDO.CCRG.RL.LOG.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    LOOP
        REMOVE REDO.CCRG.RL.LOG.ID FROM REDO.CCRG.RL.LOG.LIST SETTING REDO.CCRG.RL.LOG.MARK
    WHILE REDO.CCRG.RL.LOG.ID : REDO.CCRG.RL.LOG.MARK
        CALL F.DELETE(FN.REDO.CCRG.RL.LOG,REDO.CCRG.RL.LOG.ID)
    REPEAT

RETURN
*** </region>

*-----------------------------------------------------------------------------
*** <region name= PROCESS>
***
CHECK.PRELIM.CONDITIONS:
RETURN
*** </region>
END
