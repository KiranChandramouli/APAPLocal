*-----------------------------------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------------------------------
    SUBROUTINE REDO.E.NOF.CO.DEBTOR(AA.ARRAY)
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This is a no file enquiry routine for the enquiry REDO.ENQ.CO.DEBTOR
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.E.NOF.CO.DEBTOR
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*22.04.2010      SUDHARSANAN S   ODR-2009-10-0578     INITIAL CREATION
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.LIMIT

    GOSUB INIT
    GOSUB PROCESS
    RETURN
******
INIT:
******
    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY= ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)
    FN.AA.ARR.CUSTOMER='F.AA.ARR.CUSTOMER'
    F.AA.ARR.CUSTOMER=''
    CALL OPF(FN.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER)
    FN.AA.ARR.LIMIT='F.AA.ARR.LIMIT'
    F.AA.ARR.LIMIT=''
    CALL OPF(FN.AA.ARR.LIMIT,F.AA.ARR.LIMIT)
    FN.LIMIT='F.LIMIT'
    F.LIMIT=''
    CALL OPF(FN.LIMIT,F.LIMIT)
    CUS.ID=''
    LIMIT.CURRENCY = ''
    LIMIT.AMOUNT =''
    OUT.STAND.AMT =''
    RETURN
*********
PROCESS:
*********
    LOCATE "CUSTOMER.NO" IN D.FIELDS<1> SETTING CUS.POS THEN
        CUST.ID = D.RANGE.AND.VALUE<CUS.POS>
    END
    SEL.CMD = 'SSELECT ':FN.AA.ARR.CUSTOMER:' WITH ROLE EQ CO-SIGNER'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
    LOOP
        REMOVE SEL.ID FROM SEL.LIST SETTING AA.POS
    WHILE SEL.ID :AA.POS
        ARRANGE.ID = FIELD(SEL.ID,"-",1)
        CALL F.READ(FN.AA.ARR.CUSTOMER,SEL.ID,R.AA.CUST,F.AA.ARR.CUSTOMER,AA.ERR2)
        VAR.ROLE = R.AA.CUST<AA.CUS.ROLE>
        CHANGE VM TO FM IN VAR.ROLE
        LOCATE 'CO-SIGNER' IN VAR.ROLE SETTING POS1 THEN
            IF CUST.ID EQ R.AA.CUST<AA.CUS.OTHER.PARTY,POS1> THEN
                PRIMARY.OWNER = R.AA.CUST<AA.CUS.PRIMARY.OWNER>
                OTHER.PARTY = CUST.ID
                GOSUB GET.LIMIT.DETAILS
            END
        END
    REPEAT
    RETURN
***************************************
GET.LIMIT.DETAILS:
***************************************
    SEL.CMD3 ='SELECT ':FN.AA.ARR.LIMIT:' WITH ID.COMP.1 EQ ':ARRANGE.ID
    CALL EB.READLIST(SEL.CMD3,SEL.LIST3,'',NOR.LIMIT,ERR.LIMIT)
    CALL F.READ(FN.AA.ARR.LIMIT,SEL.LIST3,R.AA.LIMIT,F.AA.ARR.LIMIT,AA.LIMIT.ERR)
    CALL F.READ(FN.AA.ARR.LIMIT,SEL.LIST3,R.AA.LIMIT,F.AA.ARR.LIMIT,AA.LIMIT.ERR)
    LIMIT.REF = R.AA.LIMIT<AA.LIM.LIMIT.REFERENCE>
*AA Changes 20161013
    LIMIT.SERIAL = R.AA.LIMIT<AA.LIM.LIMIT.SERIAL>
*Formatting Limit reference ID
    IF LIMIT.REF THEN
*    LIMIT.REF1 =FIELD(LIMIT.REF,".",1)
*    LIMIT.REF2 =FIELD(LIMIT.REF,".",2)
*    LIMIT.REF3 = FMT(LIMIT.REF1,'R%7')
        LIMIT.REF1 = FMT(LIMIT.REF,'R%7')
*    LIMIT.REF = LIMIT.REF3:".":LIMIT.REF2
        LIMIT.REF = LIMIT.REF1:".":LIMIT.SERIAL
*AA Changes 20161013
        LIMIT.REF.NO = PRIMARY.OWNER:".":LIMIT.REF
        CALL F.READ(FN.LIMIT,LIMIT.REF.NO,R.LIMIT,F.LIMIT,LIMIT.ERR)
        LIMIT.CURRENCY = R.LIMIT<LI.LIMIT.CURRENCY>
        LIMIT.AMOUNT = R.LIMIT<LI.INTERNAL.AMOUNT>
        Y.TOTAL.OS = ''
        OS.CNT=DCOUNT(R.LIMIT<LI.TOTAL.OS>,VM)
        FOR OS.AMT=1 TO OS.CNT
            TOTAL.OS=R.LIMIT<LI.TOTAL.OS,OS.AMT>
            Y.TOTAL.OS+=TOTAL.OS
        NEXT OS.AMT
        OUT.STAND.AMT = Y.TOTAL.OS
        AA.ARRAY<-1> = ARRANGE.ID :"*":PRIMARY.OWNER:"*":OTHER.PARTY:"*":LIMIT.REF.NO:"*":LIMIT.CURRENCY:"*":LIMIT.AMOUNT:"*":OUT.STAND.AMT
    END
    RETURN
*--------------------------------------------------------------------------------------------------------------*
END
