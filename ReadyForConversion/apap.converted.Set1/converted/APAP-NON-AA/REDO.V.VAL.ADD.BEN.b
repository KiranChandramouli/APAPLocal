SUBROUTINE REDO.V.VAL.ADD.BEN
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.ADD.BEN
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-NOV-2010        Prabhu.N       ODR-2010-08-0031   Initial Creation
* 02-09-2011         PRABHU N       PACS00108341       modification
* 11-09-2011         PRABHU N       PACS00125978       modification
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System

    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.BENEFICIARY

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*---------
OPEN.PARA:
*---------
    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.CUS.BEN.LIST = 'F.CUS.BEN.LIST'
    F.CUS.BEN.LIST  = ''
    CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    CALL OPF(FN.CUS,F.CUS)

    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY  = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

RETURN

*------------
PROCESS.PARA:
*------------

    Y.BEN.TYPE   = ''
    Y.BEN.DOC.ID = ''
    Y.BEN.ACH.BANK = ''

    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CUSTOMER.ID = ""
    END

*Y.ACCOUNT=COMI
    Y.ACCOUNT=R.NEW(ARC.BEN.BEN.ACCT.NO)
    LREF.APP   ='BENEFICIARY':@FM:'CUSTOMER'
    LREF.FIELDS='L.BEN.ACCOUNT':@VM:'L.BEN.PROD.TYPE':@VM:'L.BEN.DOC.ARCIB':@VM:'L.BEN.CEDULA':@VM:'L.BEN.ACH.ARCIB':@FM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC'
    LREF.POS   =''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    FLD.POS = LREF.POS<1,2>
    DOC.POS = LREF.POS<1,3>
    CED.POS = LREF.POS<1,4>
    ACH.POS = LREF.POS<1,5>
    CUS.CED = LREF.POS<2,1>
    CUS.RNC = LREF.POS<2,2>
    CUS.NOUNICO = LREF.POS<2,3>
    CUS.ACTANAC = LREF.POS<2,4>

    Y.TYPE = R.NEW(ARC.BEN.LOCAL.REF)<1,FLD.POS>
    Y.DOC.ID = R.NEW(ARC.BEN.LOCAL.REF)<1,DOC.POS>
    Y.CED.PASAP = R.NEW(ARC.BEN.LOCAL.REF)<1,CED.POS>
    Y.ACH.BANK = R.NEW(ARC.BEN.LOCAL.REF)<1,ACH.POS>
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)

    OTH.CUS = R.ACCOUNT<AC.CUSTOMER>
*PACS00108341-S/E
    IF PGM.VERSION EQ ',AI.REDO.ADD.OTHER.BANK.BEN' OR PGM.VERSION EQ ',AI.REDO.ADD.OTHER.BANK.BEN.CONFIRM' THEN
        FLD.POS.ACC=LREF.POS<1,1>
        AF = ARC.BEN.LOCAL.REF
        AV = FLD.POS.ACC<1,1>
        GOSUB CHECK.OWN.ACCOUNT
        GOSUB CHECK.EXISTING.BEN.OTHER
        RETURN
    END
*PACS00125978-S/E
    OTH.FLG = ''

    GOSUB CHECK.ACCOUNT
    GOSUB CHECK.OWN.ACCOUNT
    IF ETEXT THEN
        RETURN
    END
    GOSUB CHECK.LOAN.ACCOUNT

    IF PGM.VERSION EQ ',AI.REDO.ADD.OWN.BANK.BEN' OR PGM.VERSION EQ ',AI.REDO.ADD.OWN.BANK.BEN.CONFIRM' THEN
        GOSUB OWN.BNK.BENIFICIARY
    END

    GOSUB CHECK.EXISTING.BEN.OWN

RETURN
*************************
OWN.BNK.BENIFICIARY:
*************************
* AF=ARC.BEN.BEN.ACCT.NO
    OTH.FLG =1
    CALL F.READ(FN.CUS,OTH.CUS,R.CUS,F.CUS,CUS.ERR)
    IF NOT(CUS.ERR) THEN

        DOC.LEGAL.ID = R.CUS<EB.CUS.LEGAL.ID>
        CIDENT.ID = R.CUS<EB.CUS.LOCAL.REF><1,CUS.CED>
        CUS.RNC.ID = R.CUS<EB.CUS.LOCAL.REF><1,CUS.RNC>
        CUS.NOUNICO.ID = R.CUS<EB.CUS.LOCAL.REF><1,CUS.NOUNICO>
        CUS.ACTANAC.ID = R.CUS<EB.CUS.LOCAL.REF><1,CUS.ACTANAC>
*        CUS.NAME.INFO = R.CUS<EB.CUS.NAME.1>
*        Y.CUS.NAME = R.NEW(ARC.BEN.L.BEN.CUST.NAME)

        PREV.AF = AF    ;* Hiding error field reference
        PREV.AV = AV

*        IF CUS.NAME.INFO NE Y.CUS.NAME THEN
*        AF = ARC.BEN.L.BEN.CUST.NAME
*           ETEXT ='EB-INVALID.ACCT'
*           CALL STORE.END.ERROR
*        END

        FLD.POS.DOC=LREF.POS<1,4>
        AF = ARC.BEN.LOCAL.REF
        AV = FLD.POS.DOC<1,1>

        BEGIN CASE
            CASE Y.DOC.ID EQ 'Cedula'
                IF Y.CED.PASAP NE CIDENT.ID THEN
                    ETEXT ='EB-INVALID.ACCT'
                    CALL STORE.END.ERROR
                END
            CASE Y.DOC.ID EQ 'Pasaporte'
                IF Y.CED.PASAP NE DOC.LEGAL.ID THEN
                    ETEXT ='EB-INVALID.ACCT'
                    CALL STORE.END.ERROR
                END
            CASE Y.DOC.ID EQ 'RNC'
                IF Y.CED.PASAP NE CUS.RNC.ID THEN

                    ETEXT ='EB-INVALID.ACCT'
                    CALL STORE.END.ERROR
                END

            CASE Y.DOC.ID EQ 'No.Unico'
                IF Y.CED.PASAP NE CUS.NOUNICO.ID THEN

                    ETEXT ='EB-INVALID.ACCT'
                    CALL STORE.END.ERROR
                END
            CASE Y.DOC.ID EQ 'Acta de Nacimiento'
                IF Y.CED.PASAP NE CUS.ACTANAC.ID THEN

                    ETEXT ='EB-INVALID.ACCT'
                    CALL STORE.END.ERROR
                END

        END CASE

        AF = PREV.AF
        AV = PREV.AV

*IF Y.DOC.ID NE DOC.LEGAL.ID THEN
* ETEXT ='EB-INVALID.ACCT'
* CALL STORE.END.ERROR

*END

    END

RETURN
*-------------
CHECK.ACCOUNT:
*-------------
    IF ACCOUNT.ER AND Y.TYPE NE 'CARDS' THEN
        ETEXT = 'EB-INVALID.ACCT'
        CALL STORE.END.ERROR
    END
RETURN
*-----------------
CHECK.OWN.ACCOUNT:
*-----------------
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.ID,R.CUST.ACC,F.CUSTOMER.ACCOUNT,ERR)

    LOCATE Y.ACCOUNT IN R.CUST.ACC SETTING Y.POS THEN
        ETEXT="EB-OWN.ACCOUNT"
        CALL STORE.END.ERROR
    END
RETURN
*------------------
CHECK.LOAN.ACCOUNT:
*------------------

    IF Y.TYPE EQ 'CARDS' THEN

        Y.ACCOUNT = FMT(Y.ACCOUNT, 'R%19')
        ACTIVATION = 'WS_T24_VPLUS'
        WS.DATA = ''
        WS.DATA<1> = 'CONSULTA_BALANCE'
        WS.DATA<2> = Y.ACCOUNT
        Y.CHANNEL = ''
        Y.MON.CHANNEL = ''
        CALL REDO.S.VP.SEL.CHANNEL(APPLICATION,PGM.VERSION,TRANS.CODE,Y.CHANNEL,Y.MON.CHANNEL)
        WS.DATA<3> = Y.CHANNEL

        CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)

        Y.CARD.CLIENT = FIELD(WS.DATA<12>,'/',1)
        Y.CARD.CLIENT = TRIM(Y.CARD.CLIENT,'0','L')
        R.NEW(ARC.BEN.BEN.ACCT.NO) = TRIM(Y.ACCOUNT,'0','L')

        OTH.CUS = FIELD(WS.DATA<12>,'/',1)
        OTH.CUS = TRIM(OTH.CUS,'0','L')

        IF WS.DATA<1> NE 'OK' THEN
            ETEXT ='EB-INVALID.ACCT'
            CALL STORE.END.ERROR
            RETURN
        END

        IF CUSTOMER.ID EQ Y.CARD.CLIENT THEN
            ETEXT="EB-OWN.CARD"
            CALL STORE.END.ERROR
        END
    END

    IF Y.TYPE EQ 'LOAN' THEN
        IF NOT(R.ACCOUNT<AC.ARRANGEMENT.ID>) THEN
            ETEXT = 'EB-NOT.LOAN.ACC'
            CALL STORE.END.ERROR
        END
    END ELSE
        IF R.ACCOUNT<AC.ARRANGEMENT.ID> THEN
            ETEXT = 'EB-IS.LOAN.ACC'
            CALL STORE.END.ERROR
        END
    END

RETURN
*----------------------
CHECK.EXISTING.BEN.OWN:
*----------------------
    CUS.BEN.LIST.ID = CUSTOMER.ID:'-OWN'
*PACS00125978-S
    BEN.ACCT.NO = R.NEW(ARC.BEN.BEN.ACCT.NO)
    CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)

    IF NOT(CUS.BEN.LIST.ER) THEN

        LOOP

            REMOVE BEN.EACH.ID FROM R.CUS.BEN.LIST SETTING BEN.LIST.POS
        WHILE BEN.EACH.ID:BEN.LIST.POS
            ACCT.BEN.ID = FIELD(BEN.EACH.ID,"*",1)
            BEN.ID = FIELD(BEN.EACH.ID,"*",2)
            IF ACCT.BEN.ID EQ BEN.ACCT.NO THEN
                ETEXT = 'EB-EXISTING.BEN'
                CALL STORE.END.ERROR
            END
        REPEAT
    END

RETURN
*------------------------
CHECK.EXISTING.BEN.OTHER:
*------------------------
    BEN.ACCT.NO = R.NEW(ARC.BEN.LOCAL.REF)<1,FLD.POS.ACC>
    CUS.BEN.LIST.ID = CUSTOMER.ID:'-OTHER'
    CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)
    IF CUS.BEN.LIST.ER THEN
        RETURN
    END

    IF NOT(CUS.BEN.LIST.ER) THEN

        LOOP

            REMOVE BEN.EACH.ID FROM R.CUS.BEN.LIST SETTING BEN.LIST.POS
        WHILE BEN.EACH.ID:BEN.LIST.POS
            ACCT.BEN.ID = FIELD(BEN.EACH.ID,"*",1)
            BEN.ID = FIELD(BEN.EACH.ID,"*",2)
            CALL CACHE.READ(FN.BENEFICIARY, BEN.ID, R.BENEFICIARY, BENEFICIARY.ERR)
            Y.BEN.TYPE   = R.BENEFICIARY<ARC.BEN.LOCAL.REF,FLD.POS>
            Y.BEN.ACH.BANK = R.BENEFICIARY<ARC.BEN.LOCAL.REF,ACH.POS>
            IF ACCT.BEN.ID EQ BEN.ACCT.NO AND  Y.ACH.BANK EQ Y.BEN.ACH.BANK THEN
                ETEXT = 'EB-EXISTING.BEN'
                CALL STORE.END.ERROR
            END
        REPEAT
    END

RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------