SUBROUTINE NOFILE.NOT.RELATED.NO.RISK.GROUP1(COLL.ARR)
*------------------------------------------------------------------------------------------
*DESCRIPTION : This is a no file enquiry routine for the enquiry ENQ.NOT.RELATED.NO.RISK.GROUP
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NACHIMUTHU
* PROGRAM NAME : NOFILE.NOT.RELATED.NO.RISK.GROUP1
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*02.07.2010      NACHIMUTHU      ODR-2009-10-0578   INITIAL CREATION
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COLLATERAL
    $INSERT I_F.CREDIT.LIMIT.MAINTENANCE



    GOSUB INIT
    GOSUB PROCESS
RETURN

*****
INIT:
*****

    COLL.ARR = ''
    COLL.DESC = ''
    RISK.DESC.COLL =''
    RISK.DESC.WC.COLL=''
    TOT.WTH.COLL=''
    TOT.WC.COLL=''
    TOT.AVAIL.WTH.COL=''
    TOT.AVAIL.WC.COLL=''
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''

    FN.CREDIT.LIMIT.MAINTENANCE = 'F.CREDIT.LIMIT.MAINTENANCE'
    F.CREDIT.LIMIT.MAINTENANCE  = ''

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''

    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    CALL OPF(FN.CREDIT.LIMIT.MAINTENANCE,F.CREDIT.LIMIT.MAINTENANCE)
    CALL OPF(FN.COMPANY,F.COMPANY)

RETURN

********
PROCESS:
********

*   LOCATE "CUSTOMER.NO" IN D.FIELDS<1> SETTING CUS.POS THEN
*   Y.CUS.ID=D.RANGE.AND.VALUE<CUS.POS>
*   END



    SEL.CMD1 ="SELECT ":FN.CUSTOMER:" WITH RELATION.CODE EQ '' AND  L.CU.GRP.RIESGO EQ ''"
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NOR1,SEL.ERR1)
    LOOP
        REMOVE Y.CUS.ID FROM SEL.LIST1 SETTING POS1
    WHILE Y.CUS.ID:POS1

        SEL.CMD2 = "SELECT ":FN.COLLATERAL:" WITH @ID LIKE " :Y.CUS.ID: "..."

        CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NOR1,SEL.ERR2)
        LOOP
            REMOVE Y.COLL.ID FROM SEL.LIST2 SETTING POS2

        WHILE Y.COLL.ID:POS2
            CALL F.READ(FN.COLLATERAL,Y.COLL.ID,R.COLLATERAL,F.COLLATERAL,COLL.ERR1)
            IF R.COLLATERAL THEN

                TOT.WTH.COLL = R.COLLATERAL<COLL.EXECUTION.VALUE>
                TOT.WC.COLL = R.COLLATERAL<COLL.NOMINAL.VALUE> - R.COLLATERAL<COLL.EXECUTION.VALUE>

                RISK.DESC.COLL = "SUMMARY OF INDIVIDUAL RISKS - WITH COLLATERAL"
                RISK.DESC.WC.COLL = "SUMMARY OF INDIVIDUAL RISKS - WITHOUT COLLATERAL"


                GOSUB FETCH.AVAILABLE.AMOUNT

            END
        REPEAT
    REPEAT


    COLL.ARR<-1> = RISK.DESC.COLL:'*':TOT.WTH.COLL:'*':TOT.AVAIL.WTH.COL
    COLL.ARR<-1>= RISK.DESC.WC.COLL:'*':TOT.WC.COLL:'*':TOT.AVAIL.WC.COLL

RETURN

FETCH.AVAILABLE.AMOUNT:
************************

    CALL CACHE.READ(FN.CREDIT.LIMIT.MAINTENANCE,'SYSTEM',R.CR.LIM.MAINT,CR.ERR1)
    IF R.CR.LIM.MAINT THEN

        TYPE.OF.GROUP = R.CR.LIM.MAINT<CRD.LIM.TYPE.OF.GROUP>
    END

    GROUP.CNT = DCOUNT(TYPE.OF.GROUP,@VM)
    CNT2 = 1
    LOOP
    WHILE CNT2 LE GROUP.CNT
        IF R.CR.LIM.MAINT<CRD.LIM.TYPE.OF.GROUP,CNT2> EQ 'RISK.GROUP.LIMIT.WITH.COLLATERAL' THEN
            TOT.AVAIL.WTH.COL = R.CR.LIM.MAINT<CRD.LIM.AVAILABLE.AMOUNT,CNT2>
        END
        IF R.CR.LIM.MAINT<CRD.LIM.TYPE.OF.GROUP,CNT2> EQ 'RISK.GROUP.LIMIT.WITHOUT.COLLATERAL' THEN
            TOT.AVAIL.WC.COLL = R.CR.LIM.MAINT<CRD.LIM.AVAILABLE.AMOUNT,CNT2>
        END
        CNT2 +=1

    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------------
END
*----------------------------------------------------------------------------------------------------------------
