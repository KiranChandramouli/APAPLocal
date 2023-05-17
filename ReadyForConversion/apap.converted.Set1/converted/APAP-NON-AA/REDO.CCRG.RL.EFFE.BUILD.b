SUBROUTINE REDO.CCRG.RL.EFFE.BUILD(OUT.DATA)
*-----------------------------------------------------------------------------
*!** Simple AUTHORISE template
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
* 02/05/11 - APAP - B5
*            First Version
*** <desc>Modification history</desc>
*-----------------------------------------------------------------------------
* Modification History:
*-----------------------------------------------------------------------------
*** </region>

*** <region name= INSERTS>
*** <desc>Inserts</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*    $INCLUDE TAM.BP I_F.REDO.CCRG.CUSTOMER
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

** <region name= INITIALISE>
*** <desc>Initialise</desc>
INITIALISE:

* Initialize variables

    PROCESS.GOAHEAD = 1
    R.REDO.CCRG.RL.EFFECTIVE  = ''

    Y.ID = ''
    Y.END.DATE = ''
    OUT.DATA = ''
    Y.ERR.MSG = ''

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
*** <desc>Process</desc>
PROCESS:

* Locate variables in I_ENQUIRY.COMMON for parameter CUS.ID

    LOCATE "CUSTOMER.ID" IN D.FIELDS<1> SETTING Y.POS.ID THEN
        Y.CUSTOMER.ID = D.RANGE.AND.VALUE <Y.POS.ID>
    END ELSE
*We use the ETEXT for error case
        ETEXT = 'ST-REDO.CCRG.EFECTIVE.DATA'
    END

    SELECT.STATEMENT = 'SELECT ':FN.REDO.CCRG.RL.EFFECTIVE:' WITH OPERATOR.ID EQ ' : OPERATOR
    SELECT.STATEMENT := ' AND OUT.DATA EQ ': "'":"'" : ' OR OUT.DATA GT ' :Y.END.DATE

    REDO.CCRG.RL.EFFECTIVE.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,REDO.CCRG.RL.EFFECTIVE.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    LOOP

        REMOVE Y.ID FROM REDO.CCRG.RL.EFFECTIVE.LIST SETTING POS

    WHILE Y.ID:POS

        R.REDO.CCRG.RL.EFFECTIVE = ''
        YERR = ''
        CALL F.READ(FN.REDO.CCRG.RL.EFFECTIVE,REDO.CCRG.RL.EFFECTIVE.ID,R.REDO.CCRG.RL.EFFECTIVE,F.REDO.CCRG.RL.EFFECTIVE,YERR)

* Exporting to OUT.DATA all Messages to enquiry

*OUT.DATA<-1>=R.REDO.CCRG.RL.EFFECTIVE<1>;*Tus Start
        OUT.DATA<-1>=R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.USER.ID>
*OUT.DATA<-1>=R.REDO.CCRG.RL.EFFECTIVE<2>
        OUT.DATA<-1>=R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.CUSTOMER.ID>
*OUT.DATA<-1>=R.REDO.CCRG.RL.EFFECTIVE<3>
        OUT.DATA<-1>=R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.START.DATE>
*OUT.DATA<-1>=R.REDO.CCRG.RL.EFFECTIVE<4>
        OUT.DATA<-1>=R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.LINK.1>
*OUT.DATA<-1>=R.REDO.CCRG.RL.EFFECTIVE<5>
        OUT.DATA<-1>=R.REDO.CCRG.RL.EFFECTIVE<REDO.CCRG.RLE.LINK.2> ;*Tus End
    REPEAT

*    CALL JOURNAL.UPDATE('')

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <desc>OpenFiles</desc>
OPEN.FILES:

* Open files REDO.CCRG.RL.EFFECTIVE

    FN.REDO.CCRG.RL.EFFECTIVE = 'F.REDO.CCRG.RL.EFFECTIVE'
    F.REDO.CCRG.RL.EFFECTIVE = ''
    CALL OPF(FN.REDO.CCRG.RL.EFFECTIVE,F.REDO.CCRG.RL.EFFECTIVE)

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <desc>CheckPrelimConditions</desc>
CHECK.PRELIM.CONDITIONS:


RETURN
*** </region>
*-----------------------------------------------------------------------------
END
