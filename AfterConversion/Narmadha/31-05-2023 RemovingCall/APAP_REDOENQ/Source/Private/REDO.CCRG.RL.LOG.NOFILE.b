* @ValidationCode : MjoyMDYxMzYwMDAwOkNwMTI1MjoxNjgyMDczMzc5NTQ0OklUU1M6LTE6LTE6MTYxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 161
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CCRG.RL.LOG.NOFILE(OUT.DATA)
*-----------------------------------------------------------------------------
*** Simple AUTHORISE template
* @author iromanvera@temenos.com
* @stereotype subroutine
* @package REDO.CCRG.
* Invoqued in E.REDO.CCRG.RL.LOG
*
*** <region name= PROGRAM DESCRIPTION>
*** <desc>Program description</desc>
*-----------------------------------------------------------------------------
* Program Description
*** </region>

*** <region name= MODIFICATION HISTORY>
* 04/12/11 - APAP - B5
*            First Version
*** <desc>Modification history</desc>
*-----------------------------------------------------------------------------
* Modification History:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 17-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C    Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
*** </region>

*** <region name= INSERTS>
*** <desc>Inserts</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    $INSERT I_F.REDO.CCRG.CUSTOMER

*** </region>
*-----------------------------------------------------------------------------

*** <region name= MAIN PROCESS LOGIC>
*** <desc>Main process logic</desc>

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
*** <desc>Process</desc>
PROCESS:


* Locate variables in I_ENQUIRY.COMMON for parameter CUS.ID

    LOCATE "CUS.ID" IN D.FIELDS<1> SETTING Y.POS.ID THEN
        Y.CUSTOMER.ID = D.RANGE.AND.VALUE <Y.POS.ID>
    END ELSE
* We use ETEXT in case of error
        ETEXT = 'ST-REDO.CCRG.EFECTIVE.DATA'
    END

* Select CUS.ID for criteria from STANDARD.SELECTION > NOFILE.REDO.CCRG.RL.LOG

    SELECT.STATEMENT = 'SELECT ':FN.REDO.CCRG.RL.LOG:' WITH @ID LIKE ':Y.CUSTOMER.ID:'...'
    REDO.CCRG.RL.LOG.LIST = ''
    LIST.NAME = ''
    SELECTED  = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,REDO.CCRG.RL.LOG.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    LOOP
        REMOVE Y.ID FROM REDO.CCRG.RL.LOG.LIST SETTING POS
    WHILE Y.ID:POS

        R.REDO.CCRG.RL.LOG = ''
        YERR = ''
        CALL F.READ(FN.REDO.CCRG.RL.LOG,Y.ID,R.REDO.CCRG.RL.LOG,F.REDO.CCRG.RL.LOG,YERR)

* Exporting to OUT.DATA all Messages to enquiry NOFILE
        OUT.DATA<-1> = R.REDO.CCRG.RL.LOG<3>

    REPEAT

    IF NOT(OUT.DATA) THEN
        OUT.DATA<1> = 'NO EXISTE INFORMACION'
    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
*** <desc>Initialise</desc>
INITIALISE:

* Initialize variables

    PROCESS.GOAHEAD     = 1
    R.REDO.CCRG.RL.LOG  = ''

    Y.ID        = ''
    OUT.DATA<1> = ''
    Y.ERR.MSG   = ''

RETURN
*** </region>

*** <desc>OpenFiles</desc>
OPEN.FILES:

* Open files REDO.CCRG.RL.EFFECTIVE

    FN.REDO.CCRG.RL.LOG = 'F.REDO.CCRG.RL.LOG'
    F.REDO.CCRG.RL.LOG = ''
    CALL OPF(FN.REDO.CCRG.RL.LOG,F.REDO.CCRG.RL.LOG)

RETURN
*** </region>

*** <desc>CheckPrelimConditions</desc>
CHECK.PRELIM.CONDITIONS:

RETURN
*** </region>

END
