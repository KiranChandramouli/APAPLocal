* @ValidationCode : MjoxNjkzNjU0Mzg2OkNwMTI1MjoxNjgwNzczNzAxMTAyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:05:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.ACH.POP.DETAILS

*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.V.ACH.POP.DETAILS
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.BANK.STOP.PAY.ACCT.LIST
* Linked with : Enquiry AI.REDO.BANK.STOP.PAY.ACCT.LIST as BUILD routine
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*23/08/11      PACS001002015          Prabhu N                MODIFICAION
*21/09/11      PACS00106561           PRABHU N                   MODIFICATION
*-----------------------------------------------------------------------------
*Modification History
*DATE                     WHO                        REFERENCE                       DESCRIPITION
*06-04-2023           Conversion Tool          R22 Auto Code conversion      FM TO @FM,VM TO @VM , ++ TO +=1 , F.READ TO CACHE.READ, IF CONDITION ADDED
*06-04-2023            Samaran T                Manual R22 Code Conversion    No Changes
*---------------------------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.REDO.ACH.PARTICIPANTS
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER

    GOSUB OPEN.FILES
    GOSUB AUTO.POP.DETAILS
    GOSUB GET.DETAILS.COMM.TYPE
RETURN
*----------*
OPEN.FILES:
*-----------*


    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

    FN.CUS.BEN.LIST='F.CUS.BEN.LIST'
    F.CUS.BEN.LIST=''
    CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)

    FN.REDO.ACH.PART='F.REDO.ACH.PARTICIPANTS'
    F.REDO.ACH.PART=''
    CALL OPF(FN.REDO.ACH.PART,F.REDO.ACH.PART)

    FN.ARCIB.PARAM='F.AI.REDO.ARCIB.PARAMETER'
    F.ARCIB.PARAM=''
    CALL OPF(FN.ARCIB.PARAM,F.ARCIB.PARAM)

    LOC.BEN.FIELD=''
    LREF.APP=''
    BEN.FLD.POS=''
    CUSTOMER.ID=''
    BEN.OTH.BANK.FLAG=''
    FT.TYPE=''
    LOC.BEN.FIELD='L.BEN.CUST.NAME':@VM:'L.BEN.BANK':@VM:'L.BEN.OWN.ACCT':@VM:'L.BEN.ACH.ARCIB':@VM:'L.BEN.CEDULA':@FM:'L.FT.ACH.B.NAM':@VM:'L.FTST.ACH.PART':@VM:'L.FT.ACH.B.ACC':@VM:'L.ACH.PART.ID'
    LOC.BEN.FIELD := @VM:'L.TT.TAX.CODE':@VM:'L.TT.WV.TAX':@VM:'L.TT.TAX.AMT'
    LREF.APP = 'BENEFICIARY':@FM:'FUNDS.TRANSFER'

    BEN.FT.FLD.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LOC.BEN.FIELD,BEN.FT.FLD.POS)
    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CODE CONVERSION
        CUSTOMER.ID = ""   ;*R22 AUTO CODE CONVERSION
    END  ;*R22 AUTO CODE CONVERSION
    BEN.CUST.NAME.POS    = BEN.FT.FLD.POS<1,1>
    BEN.BANK.NAME.POS    = BEN.FT.FLD.POS<1,2>
*PACS00106561-S
    BEN.OWN.OTH.BANK.POS = BEN.FT.FLD.POS<1,3>
    BEN.L.BEN.ACH.ARCIB.POS  = BEN.FT.FLD.POS<1,4>
*PACS00106561-E
    Y.BEN.CED.RNC.POS=BEN.FT.FLD.POS<1,5>
    FT.ACH.NAME.POS  = BEN.FT.FLD.POS<2,1>
    FT.ACH.ROUTE.POS = BEN.FT.FLD.POS<2,2>
    FT.ACH.BEN.ACCT.POS=BEN.FT.FLD.POS<2,3>
    Y.FT.BEN.CED.RNC.POS=BEN.FT.FLD.POS<2,4>
    FT.L.TT.TAX.CODE.POS  = BEN.FT.FLD.POS<2,5>
    FT.TT.WV.TAX.POS = BEN.FT.FLD.POS<2,6>
    FT.L.TT.TAX.AMT.POS = BEN.FT.FLD.POS<2,7>

    BEN.ACCT.NO=R.NEW(FT.LOCAL.REF)<1,FT.ACH.BEN.ACCT.POS>


    CALL CACHE.READ(FN.ARCIB.PARAM,'SYSTEM',R.ARCIB.PARAM.REC,ARCIB.PARAM.ERR)

    IF NOT(ARCIB.PARAM.ERR) THEN
        AI.PARAM.PROD =R.ARCIB.PARAM.REC<AI.PARAM.PRODUCT>
        AI.PARAM.TYPE=R.ARCIB.PARAM.REC<AI.PARAM.TRANSACTION.TYPE>
        AI.PARAM.CURR =R.ARCIB.PARAM.REC<AI.PARAM.CURRENCY>
        AI.PARAM.ACCT = R.ARCIB.PARAM.REC<AI.PARAM.ACCOUNT.NO>
    END

RETURN
*---------------*
AUTO.POP.DETAILS:
*---------------*
    BEN.ID=R.NEW(FT.BENEFICIARY.ID)
    CALL CACHE.READ(FN.BENEFICIARY, BEN.ID, R.BEN, BEN.ERR)  ;*R22 AUTO CODE CONVERSION
    IF NOT(BEN.ERR) THEN
        BANK.CUST.NAME=R.BEN<ARC.BEN.LOCAL.REF,BEN.CUST.NAME.POS>
        BANK.NAME = R.BEN<ARC.BEN.LOCAL.REF,BEN.BANK.NAME.POS>
        BEN.OTH.BANK.FLAG=R.BEN<ARC.BEN.LOCAL.REF,BEN.OWN.OTH.BANK.POS>
        CALL F.READ(FN.REDO.ACH.PART,BANK.NAME,R.ACH.PART,F.REDO.ACH.PART,ACH.ERR)
        IF NOT(ACH.ERR) THEN
            BANK.ROUTE.NAME=R.ACH.PART<REDO.ACH.PARTI.BANK.CODE>
        END ELSE
            ETEXT = 'EB-BANK.ALREADY.REMOVED'
            AF = FT.LOCAL.REF
            AV = FT.ACH.BEN.ACCT.POS
            AS = 1
            CALL STORE.END.ERROR
        END
        R.NEW(FT.LOCAL.REF)<1,FT.ACH.NAME.POS>=BANK.CUST.NAME
        R.NEW(FT.LOCAL.REF)<1,FT.ACH.ROUTE.POS>=BANK.NAME
        R.NEW(FT.LOCAL.REF)<1,Y.FT.BEN.CED.RNC.POS>=R.BEN<ARC.BEN.LOCAL.REF,Y.BEN.CED.RNC.POS>
    END
RETURN

*PACS00106561-S
*----------------------*
GET.DETAILS.COMM.TYPE:
*----------------------*

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        R.NEW(FT.CREDIT.THEIR.REF)=ID.NEW
        IF BEN.OTH.BANK.FLAG EQ 'YES' THEN
            R.NEW(FT.LOCAL.REF)<1,FT.L.TT.TAX.CODE.POS> = ''
            R.NEW(FT.LOCAL.REF)<1,FT.TT.WV.TAX.POS>     = 'YES'
            R.NEW(FT.LOCAL.REF)<1,FT.L.TT.TAX.AMT.POS>  = ''
        END

        BEGIN CASE
            CASE PGM.VERSION EQ ',AI.REDO.TRANSFER.OUT'
                Y.TYPE = 'THIRD-TRANSFER'
                GOSUB DEFAULT.CUSTOMER.ACCOUNT
            CASE PGM.VERSION  EQ ',AI.REDO.LOAN.OUT'
                Y.TYPE = 'THIRD-PAYMENT'
                GOSUB DEFAULT.CUSTOMER.ACCOUNT
            CASE PGM.VERSION  EQ ',AI.REDO.CARD.OUT'
                Y.TYPE = 'OTHER-CARD-PAYMENT'
                GOSUB DEFAULT.CUSTOMER.ACCOUNT
        END CASE
    END
RETURN
*-----------------------*
DEFAULT.CUSTOMER.ACCOUNT:
*-----------------------*
    Y.TOTAL.PROD = DCOUNT(AI.PARAM.PROD,@VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.TOTAL.PROD
        Y.TXN.CURRENCY  = R.NEW(FT.DEBIT.CURRENCY)
        Y.PM.TYPE = AI.PARAM.TYPE<1,Y.CNT>
        Y.PM.CURR = AI.PARAM.CURR<1,Y.CNT>
        IF Y.PM.TYPE EQ Y.TYPE AND Y.TXN.CURRENCY EQ Y.PM.CURR THEN
            R.NEW(FT.CREDIT.ACCT.NO)= AI.PARAM.ACCT<1,Y.CNT>
            RETURN
        END
        Y.CNT += 1
    REPEAT
RETURN
*PACS00106561-E
END
