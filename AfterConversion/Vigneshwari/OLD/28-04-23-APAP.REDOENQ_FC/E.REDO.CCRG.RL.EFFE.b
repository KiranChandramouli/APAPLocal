$PACKAGE APAP.REDOENQ
SUBROUTINE E.REDO.CCRG.RL.EFFE(OUT.DATA)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description: This program generate the enquiry REDO.CCRG.RL.EFFECTIVE.MONITOR
*
* Linked With:
*             ENQUIRY REDO.CCRG.RL.EFFECTIVE.MONITOR as NOFILE Rtn
*             ENQUIRY REDO.CCRG.RL.EFFECTIVE.LOG as NOFILE Rtn
*
* Out Parameter:
*               OUT.DATA  Detalle del enquiry
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 30/04/2011 - ODR-2011-03-0154
*              Description of the development associated
*              iromanvera@temenos.com
*  DATE             WHO                   REFERENCE 
* 06-APRIL-2023      Harsha                R22 Auto Conversion  - VM to @VM 
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*
    $INSERT I_GTS.COMMON
    $INSERT I_F.CUSTOMER
*
    $INSERT I_F.REDO.CCRG.RL.EFFECTIVE
*
*--------------------------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*--------------------------------------------------------------------------------------------


*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
*
*  Process to get data to show in the enquiry
*
* Locate variables in I_ENQUIRY.COMMON for parameter TYPE.ENQ
    LOCATE "TYPE.ENQ" IN D.FIELDS<1> SETTING Y.POS.ID THEN
        Y.TYPE.ENQ = D.RANGE.AND.VALUE <Y.POS.ID>
    END

* Select all record from REDO.CCRG.RL.EFFECTIVE to OPERATOR

    Y.SEL.CMD          = 'SELECT ':FN.REDO.CCRG.RL.EFFECTIVE: " WITH USER.ID EQ '" : OPERATOR : "'"
    Y.SEL.CMD          := ' AND END.DATE GT ': Y.PROCESS.DATE

    RL.EFFECTIVE.LIST  = ''
    LIST.NAME          = ''
    SELECTED           = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(Y.SEL.CMD,RL.EFFECTIVE.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

* Get Data to Show in the enquiry
    OUT.DATA = ''
    IF SELECTED NE 0 THEN
        LOOP
            REMOVE Y.EFF.ID FROM RL.EFFECTIVE.LIST SETTING RL.EFFECTIVE.MARK
        WHILE Y.EFF.ID : RL.EFFECTIVE.MARK
            GOSUB GET.DETAIL.ENQ
        REPEAT
    END

* Validate if detail has data
    IF NOT(OUT.DATA) THEN

        OUT.DATA  = '*NO EXISTE INFORMACION'
    END

RETURN
*--------------------------------------------------------------------------------------------



*--------------------------------------------------------------------------------------------
GET.DETAIL.ENQ:
*--------------------------------------------------------------------------------------------
*
* Get name of the customer from the CUSTOMER application
*

* Get effective and process records
    R.RL.EFFE = ''
    YERR      = ''
    CALL F.READ(FN.REDO.CCRG.RL.EFFECTIVE,Y.EFF.ID,R.RL.EFFE,F.REDO.CCRG.RL.EFFECTIVE,YERR)

* Set effective data
    Y.START.DATE = ''
    Y.START.DATE = R.RL.EFFE<REDO.CCRG.RLE.START.DATE>
    Y.END.DATE   = ''
    CALL S.REDO.CCRG.CALC.END.DATE(Y.END.DATE, Y.START.DATE)

* Only data for the enquiry type
    Y.SEL.DATA = 0
    IF Y.TYPE.ENQ EQ 1 AND R.RL.EFFE<REDO.CCRG.RLE.LINK.2> EQ '' THEN
        Y.SEL.DATA = 1
    END
    IF Y.TYPE.ENQ NE 1 AND R.RL.EFFE<REDO.CCRG.RLE.LINK.1> EQ '' AND R.RL.EFFE<REDO.CCRG.RLE.LINK.2> NE ''THEN
        Y.SEL.DATA = 1
    END

    IF NOT(NUM(Y.END.DATE)) THEN
        ENQ.ERROR<-1> = Y.END.DATE  ;*If existe any error in the same variable the routine return a error message
        RETURN
    END

* If the data record is effective or in process
*IF Y.END.DATE GT Y.PROCESS.DATE AND Y.SEL.DATA EQ 1 THEN
    IF Y.SEL.DATA EQ 1 THEN
* Get data customer
        Y.CUSTOMER.ID    = ''
        Y.CUSTOMER.ID    = R.RL.EFFE<REDO.CCRG.RLE.CUSTOMER.ID>
        Y.SHORT.NAME     = ''
        Y.SHORT.NAME.CUS = ''
        GOSUB GET.DATA.CUS

* Set data info
        Y.STATUS = 'Procesado'
        Y.ERRLOG = ''
        Y.LINK.1 = ''
        Y.LINK.2 = ''
        Y.LINK.1 = R.RL.EFFE<REDO.CCRG.RLE.LINK.1>
        Y.LINK.2 = R.RL.EFFE<REDO.CCRG.RLE.LINK.2>

* Set record to display in enquiry
        Y.LINE   = Y.CUSTOMER.ID: @VM :Y.SHORT.NAME.CUS: @VM :Y.START.DATE

* Set status record
        IF Y.TYPE.ENQ EQ 1 THEN
            IF Y.LINK.1 EQ '' THEN    ;*Record in process
                Y.STATUS    = ''
                Y.END.DATE  = ''
            END
            Y.LINE        := @VM :Y.END.DATE : @VM :Y.STATUS : @VM :Y.LINK.1 : @VM : SELECTED
        END ELSE
            Y.STATUS       = 'No Procesado'
            Y.LINE        := @VM :Y.END.DATE : @VM :Y.STATUS : @VM :Y.LINK.2 : @VM : SELECTED
        END

* Set data to display
        CHANGE @VM TO "*" IN Y.LINE
        OUT.DATA<-1> = Y.LINE

    END


RETURN
*--------------------------------------------------------------------------------------------


*--------------------------------------------------------------------------------------------
GET.DATA.CUS:
*--------------------------------------------------------------------------------------------
*
* Get name of the customer from the CUSTOMER application
*

    R.CUSTOMER = ''
    YERR       = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,YERR)

    IF R.CUSTOMER THEN
        Y.SHORT.NAME =  R.CUSTOMER<EB.CUS.SHORT.NAME>
        IF Y.SHORT.NAME<1,LNGG> NE '' THEN
            Y.SHORT.NAME.CUS = Y.SHORT.NAME<1,LNGG>
        END ELSE
            Y.SHORT.NAME.CUS = Y.SHORT.NAME<1,1>
        END
    END ELSE
        ENQ.ERROR<-1> = 'No existe codigo de Cliente en CUSTOMER':Y.CUSTOMER.ID
    END

RETURN
*--------------------------------------------------------------------------------------------



*--------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------
*
*  Open files
*

* Open REDO.CCRG.RL.EFFECTIVE
    FN.REDO.CCRG.RL.EFFECTIVE = 'F.REDO.CCRG.RL.EFFECTIVE'
    F.REDO.CCRG.RL.EFFECTIVE = ''
    CALL OPF(FN.REDO.CCRG.RL.EFFECTIVE,F.REDO.CCRG.RL.EFFECTIVE)

* Open CUSTOMER
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

*
RETURN

*--------------------------------------------------------------------------------------------



*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

    LOOP.CNT         = 1
    MAX.LOOPS        = 1
    PROCESS.GOAHEAD  = 1

    CALL ADD.DATE.TIME
    Y.PROCESS.DATE   = COMI


    Y.SEP            = '*'

    OUT.DATA         = ''

RETURN
*--------------------------------------------------------------------------------------------

END
