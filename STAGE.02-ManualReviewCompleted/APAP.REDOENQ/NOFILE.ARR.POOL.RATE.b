$PACKAGE APAP.REDOENQ
SUBROUTINE NOFILE.ARR.POOL.RATE(Y.RETURN.ARRAY)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is the nofile routine
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who            Reference            Description
* 01-JUL-2010    Kishore.SP     ODR-2009-10-0325      Initial Creation
*  DATE             WHO                   REFERENCE 
* 06-APRIL-2023      Harsha                R22 Auto Conversion  - ! to *
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_AA.ID.COMPONENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.SUCESS.RATE.CHANGE.COB
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB LOCATE.VALUES
    GOSUB SELECT.CMD
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------
*
* Initialise the necessary values
* open the necessary files
*
    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
*
    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AAA = ''
    CALL OPF(FN.AAA,F.AAA)


*
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.REDO.SUCESS.RATE.CHANGE.COB = 'F.REDO.SUCESS.RATE.CHANGE.COB'
    F.REDO.SUCESS.RATE.CHANGE.COB  = ''
    CALL OPF(FN.REDO.SUCESS.RATE.CHANGE.COB,F.REDO.SUCESS.RATE.CHANGE.COB)


*
    LOC.REF.APPL     =  "AA.PRD.DES.INTEREST"
    LOC.REF.FIELDS   =   "L.AA.POOL.RATE":@VM:"L.AA.INT.AMTOLD":@VM:"L.AA.INT.AMTNEW":@VM:"L.AA.DIFF.AMT"
    LOC.REF.POS      = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.POOL.RATE.POS  = LOC.REF.POS<1,1>
    Y.AMT.OLD.POS    = LOC.REF.POS<1,2>
    Y.AMT.NEW.POS    = LOC.REF.POS<1,3>
    Y.DIFF.AMT.POS   = LOC.REF.POS<1,4>
*
    Y.LOAN.NUM     = ''
    Y.PRODUCT      = ''
    Y.CUSTOMER     = ''
    Y.ACCOUNT.OFF  = ''
    Y.SECTOR       = ''
    Y.BRANCH.ID    = ''
    Y.RETURN.ARRAY = ''
*
RETURN
*-------------------------------------------------------------------------------------------------
LOCATE.VALUES:
*-------------
* Locate the values from selection criteria
*
    LOCATE "LOAN.PRODUCT" IN D.FIELDS<1> SETTING Y.PRD.POS THEN
        Y.PROD.OPER        = D.LOGICAL.OPERANDS<Y.PRD.POS>
        Y.PRODUCT          = D.RANGE.AND.VALUE<Y.PRD.POS>
    END
*
    LOCATE "LOAN.NUMBER" IN D.FIELDS<1> SETTING Y.LON.POS THEN
        Y.LOAN.OPER     = D.LOGICAL.OPERANDS<Y.LON.POS>
        Y.LOAN.NUM      = D.RANGE.AND.VALUE<Y.LON.POS>
    END
*
    LOCATE "CUSTOMER" IN D.FIELDS<1> SETTING Y.LON.POS THEN
        Y.CUS.OPER      = D.LOGICAL.OPERANDS<Y.LON.POS>
        Y.CUSTOMER      = D.RANGE.AND.VALUE<Y.LON.POS>
    END
*
    LOCATE "ACCOUNT.OFF" IN D.FIELDS<1> SETTING Y.LON.POS THEN
        Y.ACT.OFF.OPER     = D.LOGICAL.OPERANDS<Y.LON.POS>
        Y.ACCOUNT.OFF      = D.RANGE.AND.VALUE<Y.LON.POS>
    END
*
    LOCATE "SECTOR" IN D.FIELDS<1> SETTING Y.LON.POS THEN
        Y.SECTOR.OPER     = D.LOGICAL.OPERANDS<Y.LON.POS>
        Y.SECTOR          = D.RANGE.AND.VALUE<Y.LON.POS>
    END
*
    LOCATE "BRANCH.ID" IN D.FIELDS<1> SETTING Y.LON.POS THEN
        Y.BRANCH.OPER     = D.LOGICAL.OPERANDS<Y.LON.POS>
        Y.BRANCH.ID       = D.RANGE.AND.VALUE<Y.LON.POS>
    END
*
RETURN
*-------------------------------------------------------------------------------------------------
SELECT.CMD:
*-----------
* Form a select command depending upon the selection criteria
*
    SEL.AA.CMD = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT EQ ":Y.PRODUCT:" AND WITH CO.CODE EQ  ":Y.BRANCH.ID
*
* If loan number is given in selection criteria
*
    IF  Y.LOAN.NUM  NE '' THEN
        SEL.AA.CMD:= " AND WITH @ID EQ ":Y.LOAN.NUM
    END
*
* If customer is given in the selection criterai
*
    IF Y.CUSTOMER NE '' THEN
        SEL.AA.CMD:= " AND WITH CUSTOMER EQ ":Y.CUSTOMER
    END
*
    GOSUB AA.SELECT.PROC
RETURN
*-------------------------------------------------------------------------------------------------
AA.SELECT.PROC:
*---------------
* selection the arrangement id's
*

    Y.SEL.AA.LIST = ''
    CALL EB.READLIST(SEL.AA.CMD,Y.SEL.AA.LIST,'',Y.SEL.AA.CNT,Y.AA.SEL.ERR)
    LOOP
        REMOVE Y.AA.ID FROM Y.SEL.AA.LIST SETTING Y.AA.POS
    WHILE Y.AA.ID:Y.AA.POS
        Y.FLAG = ''
        GOSUB CHECK.LOCAL.TEMP
*
        IF Y.FLAG EQ '1' THEN
            R.AA.ARRANGEMENT = ''
            CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.AA.ERR)
            Y.CUSTOMER.ID = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
            Y.COMPANY     = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
            GOSUB GET.CUSTOMER
            GOSUB AA.INTEREST.PROCESS
            GOSUB RETURN.ARRAY
        END
*
    REPEAT
RETURN
*-------------------------------------------------------------------------------------------------
GET.CUSTOMER:
*-------------
* Reading the customer record
*
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUST)
    Y.CUS.SECTOR   = R.CUSTOMER<EB.CUS.SECTOR>
    Y.ACCT.OFF     = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
    GOSUB CHECK.CUSTOMER
RETURN
*-------------------------------------------------------------------------------------------------
CHECK.CUSTOMER:
*--------------
* If account officer is given in selection criteria
*
    IF Y.ACCOUNT.OFF NE '' THEN
        IF Y.ACCT.OFF NE Y.ACCOUNT.OFF THEN
            RETURN
        END
    END
*
* If sector is given in the selection criteria
*
    IF Y.SECTOR NE '' THEN
        IF Y.CUS.SECTOR NE Y.SECTOR THEN
            RETURN
        END
    END
*
RETURN
*-------------------------------------------------------------------------------------------------

AA.INTEREST.PROCESS:
*--------------------
* Get the Interest values for the arrangement
*
    Y.ARRG.ID = Y.AA.ID

    PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
    CALL REDO.GET.INTEREST.PROPERTY(Y.ARRG.ID,PROP.NAME,OUT.PROP,ERR)
    Y.PRIN.PROP=OUT.PROP        ;* This variable hold the value of principal interest property

    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PRIN.PROP
    EFF.DATE = Y.INT.CHANGE.DATE
    ERR.MSG = ''
    R.INT.ARR.COND = ''
    Y.INT.RATE.NEW  = ''
    Y.POOL.RATE = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG)
    Y.LOAN.NUMBER    = Y.ARRG.ID
    Y.INT.RATE.NEW   = R.INT.ARR.COND<AA.INT.EFFECTIVE.RATE>
    Y.POOL.RATE      = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.POOL.RATE.POS>
    Y.AMT.OLD        = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.AMT.OLD.POS>
    Y.AMT.NEW        = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.AMT.NEW.POS>
    Y.AMT.DIFF       = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.DIFF.AMT.POS>

    IN.ACC.ID = ''
    IN.ARR.ID = Y.ARRG.ID
    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.AC.ID,ERR.TEXT)
    Y.AA.ACC.ID = OUT.AC.ID
    GOSUB GET.OLD.INT.RATE
    GOSUB GET.AUDIT.DETAILS

RETURN
*-------------------------------------------------------------------------------------------------
GET.OLD.INT.RATE:
*-------------------------------------------------------------------------------------------------

    idPropertyClass = 'INTEREST'
    OPTION=''
    R.PROPERTY=''
    RET.ERROR=''
    ID.COMPONENT = ""
    ID.COMPONENT<AA.IDC.ARR.NO> = Y.ARRG.ID
    ID.COMPONENT<AA.IDC.PROPERTY> = Y.PRIN.PROP
*IF idPropertyClass EQ "INTEREST" THEN
*END ELSE
*ID.COMPONENT<AA.IDC.PROPERTY> = PS.PROPERTY
*END


    ID.COMPONENT<AA.IDC.EFF.DATE> = EFF.DATE
    CALL AA.GET.PREVIOUS.PROPERTY.RECORD(OPTION, idPropertyClass , ID.COMPONENT, Y.EFFECTIVE.DATE, R.OLD.PROPERTY.REC, RET.ERROR)
    Y.OLD.EFFECTIVE.RATE =  R.OLD.PROPERTY.REC<AA.INT.EFFECTIVE.RATE>
    Y.POOL.RATE.OLD      =  R.OLD.PROPERTY.REC<AA.INT.LOCAL.REF><1,Y.POOL.RATE.POS>

RETURN
*-------------------------------------------------------------------------------------------------
GET.AUDIT.DETAILS:
*-------------------------------------------------------------------------------------------------
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.ARRG.ID,R.ACT.HIST,F.AA.ACTIVITY.HISTORY,ACT.HIST.ERR)
    Y.ACTIVITY = 'LENDING-CHANGE-':Y.PRIN.PROP
    LOCATE Y.INT.CHANGE.DATE IN R.ACT.HIST<AA.AH.EFFECTIVE.DATE,1> SETTING POS.DATE THEN
        LOCATE Y.ACTIVITY IN R.ACT.HIST<AA.AH.ACTIVITY,POS.DATE,1> SETTING POS1 THEN
            Y.AAA.ID = R.ACT.HIST<AA.AH.ACTIVITY.REF,POS.DATE,POS1>
        END
    END
    IF Y.AAA.ID THEN
        CALL F.READ(FN.AAA,Y.AAA.ID,R.AAA,F.AAA,AAA.ERR)
        Y.INPUTTER   = R.AAA<AA.ARR.ACT.INPUTTER>
        Y.AUTHORISER = R.AAA<AA.ARR.ACT.AUTHORISER>
    END

RETURN
*-------------------------------------------------------------------------------------------------
CHECK.LOCAL.TEMP:
*----------------
    Y.TEMP.ID = Y.AA.ID
    R.REDO.SUCESS.RATE.CHANGE.COB = ''
    CALL F.READ(FN.REDO.SUCESS.RATE.CHANGE.COB,Y.TEMP.ID,R.REDO.SUCESS.RATE.CHANGE.COB,F.REDO.SUCESS.RATE.CHANGE.COB,Y.TEMP.ERR)
    IF R.REDO.SUCESS.RATE.CHANGE.COB NE '' THEN
        Y.INT.CHANGE.DATE = R.REDO.SUCESS.RATE.CHANGE.COB<REDO.SUC.COB.DATE>
        Y.FLAG = '1'
    END
RETURN
*-------------------------------------------------------------------------------------------------
RETURN.ARRAY:
*------------
* The final return value
*
*IF Y.RETURN.ARRAY NE '' THEN
*Y.RETURN.ARRAY<-1> = Y.LOAN.NUMBER:'*':Y.AMT.OLD:'*':Y.AMT.NEW:'*':Y.AMT.DIFF:'*':Y.INT.CHANGE.DATE
    Y.RETURN.ARRAY<-1> = Y.AA.ACC.ID:'*':Y.OLD.EFFECTIVE.RATE:'*':Y.INT.RATE.NEW:'*':Y.POOL.RATE.OLD:'*':Y.POOL.RATE:'*':Y.AMT.OLD:'*':Y.AMT.NEW:'*':Y.AMT.DIFF:'*':Y.INT.CHANGE.DATE:'*':Y.INPUTTER:'*':Y.AUTHORISER
*END ELSE
*Y.RETURN.ARRAY     = Y.LOAN.NUMBER:'*':Y.AMT.OLD:'*':Y.AMT.NEW:'*':Y.AMT.DIFF:'*':Y.INT.CHANGE.DATE
*END
*
    Y.LOAN.NUMBER = ''
    Y.AMT.OLD     = ''
    Y.AMT.NEW     = ''
    Y.AMT.DIFF    = ''
    Y.POOL.RATE   = ''
    Y.INT.CHANGE.DATE = ''
    Y.AA.ACC.ID = ''
    Y.OLD.EFFECTIVE.RATE = ''
    Y.INT.RATE.NEW = ''
    Y.INPUTTER = ''
    Y.AUTHORISER = ''
*
RETURN
*-------------------------------------------------------------------------------------------------
END
