* @ValidationCode : MjotMTc5NzE1NDY0MTpDcDEyNTI6MTY4NTU0NTE2OTE0MDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 20:29:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CCRG.CUSTOMER.AUTHORISE
*-----------------------------------------------------------------------------
*!** Simple AUTHORISE template
* @author anoriega@temenos.com
* @author iromanvera@temenos.com
* @stereotype subroutine
* @package infra.eb
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
** 05-04-2023 R22 Auto Conversion no changes
** 05-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
*** </region>

*** <region name= INSERTS>
*** <desc>Inserts</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.CCRG.CUSTOMER
    $INSERT I_F.REDO.CCRG.RL.EFFECTIVE
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

* Register Consulted Customer in REDO.CCRG.RL.EFFECTIVE to show process in monitor enquiry

    GOSUB EFFECTIVE.DATA

* Delete Log from process for the customer

* APAP.TAM.S.REDO.CCRG.RL.DEL.LOG(R.NEW(REDO.CCRG.CUS.CUSTOMER.ID))
    APAP.TAM.sRedoCcrgRlDelLog(R.NEW(REDO.CCRG.CUS.CUSTOMER.ID)) ;* R22 manual conversion
* Register Consulted Customer of REDO.CCRG.CUSTOMER application in REDO.CCRG.EVA.QUEUE

    GOSUB EVALUATION.QUEUE


RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= EFFECTIVE.DATA>
*** <desc>Process</desc>
EFFECTIVE.DATA:

* Register Consulted Customer in REDO.CCRG.RL.EFFECTIVE to show process in monitor enquiry

    REDO.CCRG.RL.EFFECTIVE.ID = OPERATOR : '-' : R.NEW(REDO.CCRG.CUS.CUSTOMER.ID)

    R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.USER.ID>       = OPERATOR
    R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.CUSTOMER.ID>   = R.NEW(REDO.CCRG.CUS.CUSTOMER.ID)
    R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.START.DATE>    = Y.DATE
    R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.LINK.1>        = ''
    R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.LINK.2>        = ''

    CALL F.WRITE(FN.REDO.CCRG.RL.EFFECTIVE,REDO.CCRG.RL.EFFECTIVE.ID,R.REDO.CCRG.RL.EFFECTIVE)

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= EVALUATION.QUEUE>
*** <desc>Process</desc>
EVALUATION.QUEUE:

* Register Consulted Customer of REDO.CCRG.CUSTOMER application in REDO.CCRG.EVA.QUEUE

    R.REDO.CCRG.EVA.QUEUE = ''
    YERR = ''
    REDO.CCRG.EVA.QUEUE.ID = ID.NEW
    CALL F.READ(FN.REDO.CCRG.EVA.QUEUE,REDO.CCRG.EVA.QUEUE.ID,R.REDO.CCRG.EVA.QUEUE,F.REDO.CCRG.EVA.QUEUE,YERR)
    IF NOT(R.REDO.CCRG.EVA.QUEUE) THEN
        CALL F.WRITE(FN.REDO.CCRG.EVA.QUEUE,REDO.CCRG.EVA.QUEUE.ID,R.REDO.CCRG.EVA.QUEUE)
    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
*** <desc>Initialise</desc>
INITIALISE:

* Initialize variables

    PROCESS.GOAHEAD = 1

    FN.REDO.CCRG.RL.EFFECTIVE = 'F.REDO.CCRG.RL.EFFECTIVE'
    F.REDO.CCRG.RL.EFFECTIVE  = ''

    FN.REDO.CCRG.EVA.QUEUE    = 'F.REDO.CCRG.EVA.QUEUE'
    F.REDO.CCRG.EVA.QUEUE     = ''

* Assign date and time to Y.DATE

    CALL ADD.DATE.TIME
    Y.DATE = COMI

RETURN
*** </region>

*** <desc>OpenFiles</desc>
OPEN.FILES:

* Open files REDO.CCRG.RL.EFFECTIVE and REDO.CCRG.EVA.QUEUE

    CALL OPF(FN.REDO.CCRG.RL.EFFECTIVE,F.REDO.CCRG.RL.EFFECTIVE)
    CALL OPF(FN.REDO.CCRG.EVA.QUEUE,F.REDO.CCRG.EVA.QUEUE)

RETURN
*** </region>

*** <desc>CheckPrelimConditions</desc>
CHECK.PRELIM.CONDITIONS:

* Validate the effective of the data for the consulted customer, for NO

    IF R.NEW(REDO.CCRG.CUS.IGNORE.EFFECTIVE) EQ 'NO' THEN

* Select the last record inputted in REDO.CCRG.RL.EFFECTIVE for the consulted customer
* to get last START.DATE

        Y.SEL.CMD = 'SELECT ': FN.REDO.CCRG.RL.EFFECTIVE : ' WITH CUSTOMER.ID EQ ' : R.NEW(REDO.CCRG.CUS.CUSTOMER.ID)
        Y.SEL.CMD := 'BY-DSND START.DATE '
        REDO.CCRG.RL.EFFECTIVE.LIST = ''
        LIST.NAME = ''
        SELECTED  = ''
        SYSTEM.RETURN.CODE = ''
        CALL EB.READLIST(Y.SEL.CMD,REDO.CCRG.RL.EFFECTIVE.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

* Extract and assign date and time to START.DATE

        IF REDO.CCRG.RL.EFFECTIVE.LIST THEN

            REMOVE REDO.CCRG.RL.EFFECTIVE.ID FROM REDO.CCRG.RL.EFFECTIVE.LIST SETTING REDO.CCRG.RL.EFFECTIVE.MARK

            R.REDO.CCRG.RL.EFFECTIVE = ''
            YERR = ''
            CALL F.READ(FN.REDO.CCRG.RL.EFFECTIVE,REDO.CCRG.RL.EFFECTIVE.ID,R.REDO.CCRG.RL.EFFECTIVE,F.REDO.CCRG.RL.EFFECTIVE,YERR)

            Y.START.DATE = ''
            Y.START.DATE = R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.START.DATE>

* Get effective date for the consulted customer in routine S.REDO.CCRG.CALC.END.DATE by parameters

            Y.EFFECTIVE.DATE = ''
* APAP.TAM.S.REDO.CCRG.CALC.END.DATE(Y.EFFECTIVE.DATE,Y.START.DATE)
            APAP.TAM.sRedoCcrgCalcEndDate(Y.EFFECTIVE.DATE,Y.START.DATE) ;* R22 manual concersion
* Validate date and time of Y.EFFECTIVE.DATE

            IF Y.EFFECTIVE.DATE GT Y.DATE THEN
                ETEXT = 'ST-REDO.CCRG.EFECTIVE.DATA'
                PROCESS.GOAHEAD = 0
                CALL STORE.END.ERROR
            END

        END
    END

RETURN
*** </region>

END
