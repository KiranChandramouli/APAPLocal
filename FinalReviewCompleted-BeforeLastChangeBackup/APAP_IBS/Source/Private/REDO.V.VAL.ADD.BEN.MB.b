* @ValidationCode : MjotMzIyMzgxMDQ4OkNwMTI1MjoxNjk4NDA1NTQwMzk3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:49:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-108</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.VAL.ADD.BEN.MB
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
*   Date               who           Reference                       Description
* 16-NOV-2010        Prabhu.N       ODR-2010-08-0031                Initial Creation
* 02-09-2011         PRABHU N       PACS00108341                    modification
* 11-09-2011         PRABHU N       PACS00125978                    modification
* 25/10/2023         VIGNESHWARI    MANUAL R23 CODE CONVERSION      VM TO @VM,FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------

*-------------------------------------------------------------------------------------

    $INCLUDE I_COMMON
    $INCLUDE I_EQUATE
    $INCLUDE I_System

    $INCLUDE I_F.ACCOUNT
    $INCLUDE I_F.CUSTOMER
    $INCLUDE I_F.BENEFICIARY
    $INCLUDE I_F.AA.PRODUCT
    $INCLUDE I_F.AA.ARRANGEMENT
    $INSERT I_ENQUIRY.COMMON

*-------------------------------------------------------------------------------------

    GOSUB OPEN.PARA

    GOSUB PROCESS.PARA

    RETURN

*-------------------------------------------------------------------------------------
OPEN.PARA:
*---------
    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

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

*-------------------------------------------------------------------------------------
PROCESS.PARA:
*------------

    Y.BEN.TYPE   = ''
    Y.BEN.DOC.ID = ''
    Y.BEN.ACH.BANK = ''

    CUSTOMER.ID = R.NEW(ARC.BEN.OWNING.CUSTOMER)  ;*System.getVariable('EXT.SMS.CUSTOMERS')

!Y.ACCOUNT=COMI
    Y.ACCOUNT=R.NEW(ARC.BEN.BEN.ACCT.NO)
*    LREF.APP   ='BENEFICIARY':FM:'CUSTOMER'
*    LREF.FIELDS='L.BEN.ACCOUNT':VM:'L.BEN.PROD.TYPE':VM:'L.BEN.DOC.ARCIB':VM:'L.BEN.CEDULA':VM:'L.BEN.ACH.ARCIB':FM:'L.CU.CIDENT':VM:'L.CU.RNC':VM:'L.CU.NOUNICO':VM:'L.CU.ACTANAC'
    LREF.APP   ='BENEFICIARY':@FM:'CUSTOMER':@FM:'ACCOUNT'
    LREF.FIELDS='L.BEN.ACCOUNT':@VM:'L.BEN.PROD.TYPE':@VM:'L.BEN.DOC.ARCIB':@VM:'L.BEN.CEDULA':@VM:'L.BEN.ACH.ARCIB':@FM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@FM:'L.AC.STATUS1'

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

    POS.L.AC.STATUS1  =  LREF.POS<3,1>

    Y.L.BEN.ACCOUNT.POS = LREF.POS<1,1>
    Y.L.BEN.ACCOUNT = R.NEW(ARC.BEN.LOCAL.REF)<1,Y.L.BEN.ACCOUNT.POS>

    Y.TYPE = R.NEW(ARC.BEN.LOCAL.REF)<1,FLD.POS>
    Y.DOC.ID = R.NEW(ARC.BEN.LOCAL.REF)<1,DOC.POS>
    Y.CED.PASAP = R.NEW(ARC.BEN.LOCAL.REF)<1,CED.POS>
    Y.ACH.BANK = R.NEW(ARC.BEN.LOCAL.REF)<1,ACH.POS>
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)

    OTH.CUS = R.ACCOUNT<AC.CUSTOMER>
!PACS00108341-S/E
    IF PGM.VERSION EQ ',MB.REDO.ADD.OTHER.BANK.BEN'  THEN
        FLD.POS.ACC=LREF.POS<1,1>
        AF = ARC.BEN.LOCAL.REF
        AV = FLD.POS.ACC<1,1>
        GOSUB CHECK.OWN.ACCOUNT
        GOSUB CHECK.EXISTING.BEN.OTHER
        RETURN
    END
!PACS00125978-S/E
    OTH.FLG = ''

    GOSUB CHECK.ACCOUNT
    GOSUB CHECK.OWN.ACCOUNT
    IF ETEXT THEN
        RETURN
    END
    GOSUB CHECK.LOAN.ACCOUNT

    IF PGM.VERSION EQ ',MB.REDO.ADD.OWN.BANK.BEN'  THEN
        GOSUB OWN.BNK.BENIFICIARY
    END

    GOSUB CHECK.EXISTING.BEN.OWN

    RETURN
*-------------------------------------------------------------------------------------
OWN.BNK.BENIFICIARY:
*-------------------

! AF=ARC.BEN.BEN.ACCT.NO
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

        PREV.AF = AF          ;* Hiding error field reference
        PREV.AV = AV

*        IF CUS.NAME.INFO NE Y.CUS.NAME THEN
*        AF = ARC.BEN.L.BEN.CUST.NAME
*           ETEXT ='EB-INVALID.ACCT'
*           CALL STORE.END.ERROR
*        END

        FLD.POS.DOC=LREF.POS<1,4>
        AF = ARC.BEN.LOCAL.REF
        AV = FLD.POS.DOC<1,1>
*PRINT 'TEST ' :Y.CED.PASAP  : ' NE ' : CIDENT.ID
        BEGIN CASE
        CASE Y.DOC.ID EQ 'Cedula'
            IF Y.CED.PASAP NE CIDENT.ID THEN
            PRINT 'ERROR ' :Y.CED.PASAP  : ' NE ' : CIDENT.ID
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

!IF Y.DOC.ID NE DOC.LEGAL.ID THEN
! ETEXT ='EB-INVALID.ACCT'
! CALL STORE.END.ERROR

!END

    END

    RETURN

*-------------------------------------------------------------------------------------
CHECK.ACCOUNT:
*-------------

    IF ACCOUNT.ER AND Y.TYPE NE 'CARDS' THEN
        ETEXT = 'EB-INVALID.ACCT'
        CALL STORE.END.ERROR
    END
    ARRANGEMENT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>


    IF ARRANGEMENT.ID NE "" THEN
        GOSUB GET.AA.LOAN.STATUS
        IF LOAN.STATUS NE "CURRENT" THEN
            ETEXT = 'INVALID LOAN STATUS'
            CALL STORE.END.ERROR
        END
    END
*  IF R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.STATUS1> NE "ACTIVE" AND Y.TYPE NE 'CARDS' THEN
*      ETEXT = 'EB-INVALID.ACCT'
*      CALL STORE.END.ERROR
*  END

    CALL F.READ(FN.CUS,CUSTOMER.ID,R.CUSTOMER,F.CUS,ERR)
    IF R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> NE 1 THEN
        ETEXT = 'INVALID CUSTOMER STATUS '
        CALL STORE.END.ERROR
    END

    RETURN

*-------------------------------------------------------------------------------------
CHECK.OWN.ACCOUNT:
*-----------------

    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.ID,R.CUST.ACC,F.CUSTOMER.ACCOUNT,ERR)

    LOCATE Y.ACCOUNT IN R.CUST.ACC SETTING Y.POS THEN
        ETEXT="EB-OWN.ACCOUNT"
        CALL STORE.END.ERROR
    END

    RETURN

*-------------------------------------------------------------------------------------
CHECK.LOAN.ACCOUNT:
*------------------

    IF Y.TYPE EQ 'CARDS' THEN

        Y.ACCOUNT = FMT(Y.L.BEN.ACCOUNT, 'R%19')
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
*        R.NEW(ARC.BEN.BEN.ACCT.NO) = TRIM(Y.ACCOUNT,'0','L')
        R.NEW(ARC.BEN.BEN.ACCT.NO) = 'DOP1280400010017'

        OTH.CUS = FIELD(WS.DATA<12>,'/',1)
        OTH.CUS = TRIM(OTH.CUS,'0','L')

        IF WS.DATA<1> NE 'OK' THEN
            ETEXT ='EB-INVALID.ACCT ': Y.ACCOUNT
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

*-------------------------------------------------------------------------------------
CHECK.EXISTING.BEN.OWN:
*----------------------

    CUS.BEN.LIST.ID = CUSTOMER.ID:'-OWN'
!PACS00125978-S

    BEN.ACCT.NO = R.NEW(ARC.BEN.BEN.ACCT.NO)
    IF Y.TYPE EQ "CARDS" THEN
        BEN.ACCT.NO = Y.L.BEN.ACCOUNT
    END
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

*-------------------------------------------------------------------------------------
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
            CALL F.READ(FN.BENEFICIARY,BEN.ID,R.BENEFICIARY,F.BENEFICIARY,BENEFICIARY.ERR)
            Y.BEN.TYPE   = R.BENEFICIARY<ARC.BEN.LOCAL.REF,FLD.POS>
            Y.BEN.ACH.BANK = R.BENEFICIARY<ARC.BEN.LOCAL.REF,ACH.POS>
            IF ACCT.BEN.ID EQ BEN.ACCT.NO AND  Y.ACH.BANK EQ Y.BEN.ACH.BANK THEN
                ETEXT = 'EB-EXISTING.BEN'
                CALL STORE.END.ERROR
            END
        REPEAT
    END

    RETURN


GET.AA.LOAN.STATUS:
*------------------

    LOAN.STATUS =  ""
    AA.ERR = ''
    CALL F.READ(FN.AA.ARRANGEMENT, ARRANGEMENT.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, AA.ERR)
    IF NOT(AA.ERR) THEN

        O.DATA = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>:'*':ARRANGEMENT.ID

        CALL REDO.CK.PAYOFF.ESTATUS

        LOAN.STATUS = O.DATA

    END

    RETURN


END

*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------
