* @ValidationCode : MjotNjAzMDQ1NTgwOkNwMTI1MjoxNjgwNjE5NzU3Nzg1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 20:19:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CCRG.TECHNICAL.RESERVES.AUTHORISE
*-----------------------------------------------------------------------------
*!** Simple AUTHORISE template
* @author avelasco@temenos.com
* @stereotype subroutine
* @package infra.eb
*

*** <region name= PROGRAM DESCRIPTION>
*** <desc>Program description</desc>
*-----------------------------------------------------------------------------
* Program Description
*** </region>

*** <region name= MODIFICATION HISTORY>
* 17/05/11 - APAP - B5
*            First Version
*** <desc>Modification history</desc>
*-----------------------------------------------------------------------------
* Modification History:
*
* Date           Who                 Ref                  Modification
* 04.04.2023    Conversion Tool      R22                 Auto Conversion     - No changes
* 04.04.2023    Shanmugapriya M      R22                 Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
*** </region>

*** <region name= INSERTS>
*** <desc>Inserts</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.CCRG.TECHNICAL.RESERVES
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
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

* Recalculate and Update Risk limits Amounts

    GOSUB UPDATE.RISK.LIMIT


* Actualize data


RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= EFFECTIVE.DATA>
*** <desc>Process</desc>
UPDATE.RISK.LIMIT:

    Y.SEL.CMD = 'SELECT ': FN.REDO.CCRG.RISK.LIMIT.PARAM

    REDO.CCRG.RISK.LIMIT.PARAM.LIST = ''
    LIST.NAME = ''
    SELECTED  = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(Y.SEL.CMD,REDO.CCRG.RISK.LIMIT.PARAM.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    IF SELECTED NE 0 THEN
        LOOP
            REMOVE Y.RISK.LIMIT.ID FROM REDO.CCRG.RISK.LIMIT.PARAM.LIST SETTING POS1
        WHILE Y.RISK.LIMIT.ID:POS1 AND PROCESS.GOAHEAD
            GOSUB RECALCULATE.AMOUNT
        REPEAT
    END


RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= RECALCULATE.AMOUNT>
*** <desc>Process</desc>
RECALCULATE.AMOUNT:

    CALL F.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.RISK.LIMIT.ID,R.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM,Y.ERR)

    IF R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.PERCENTAGE> GT 0 THEN
        R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.AMOUNT> = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.PERCENTAGE> * R.NEW(REDO.CCRG.TR.TECH.RES.AMOUNT) / 100
        CALL F.WRITE(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.RISK.LIMIT.ID, R.REDO.CCRG.RISK.LIMIT.PARAM)
    END



RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= INITIALISE>
*** <desc>Initialise</desc>
INITIALISE:

* Initialize variables

    PROCESS.GOAHEAD = 1

    FN.REDO.CCRG.RISK.LIMIT.PARAM    = 'F.REDO.CCRG.RISK.LIMIT.PARAM'
    F.REDO.CCRG.RISK.LIMIT.PARAM     = ''


RETURN
*** </region>

*** <desc>OpenFiles</desc>
OPEN.FILES:

* Open files

    CALL OPF(FN.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM)

RETURN
*** </region>

*** <desc>CheckPrelimConditions</desc>
CHECK.PRELIM.CONDITIONS:

* Validate if the Technical Reserve Amount has changed
    Y.NEW.AMOUNT = R.NEW(REDO.CCRG.TR.TECH.RES.AMOUNT)
    Y.OLD.AMOUNT = R.OLD(REDO.CCRG.TR.TECH.RES.AMOUNT)

    IF Y.NEW.AMOUNT NE Y.OLD.AMOUNT  THEN
        PROCESS.GOAHEAD = 1
*  We must to recalculate the MaxAmount in RISK.LIMIT.PARAM
    END ELSE
        PROCESS.GOAHEAD = 0
    END

RETURN
*** </region>

END
