* @ValidationCode : MjotMTkxNTMzOTQ1ODpDcDEyNTI6MTY4MDc3NTI2ODc0MDpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:31:08
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
SUBROUTINE REDO.V.ACH.TRF.STO.POP.DETAILS

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
*DATE                    WHO                         REFERENCE                      DESCRIPITION
*06-04-2023           Conversion Tool          R22 Auto Code conversion      VM TO @VM , F.READ TO CACHE.READ,IF CONDITION ADDED
*06-04-2023            Samaran T                Manual R22 Code Conversion    No Changes
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_System
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.REDO.ACH.PARTICIPANTS
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER

    GOSUB OPEN.FILES
    GOSUB AUTO.POP.DETAILS
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

    LOC.BEN.FIELD=''
    LREF.APP=''
    BEN.FLD.POS=''
    CUSTOMER.ID=''
    BEN.OTH.BANK.FLAG=''
    FT.TYPE=''
    LOC.BEN.FIELD='L.BEN.CUST.NAME':@VM:'L.BEN.BANK':@VM:'L.BEN.OWN.ACCT':@VM:'L.BEN.ACH.ARCIB':@VM:'L.BEN.CEDULA'
    LREF.APP = 'BENEFICIARY'

    BEN.FT.FLD.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LOC.BEN.FIELD,BEN.FT.FLD.POS)
    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CODE CONVERSION
        CUSTOMER.ID = ""  ;*R22 AUTO CODE CONVERSION
    END  ;*R22 AUTO CODE CONVERSION
    BEN.CUST.NAME.POS    = BEN.FT.FLD.POS<1,1>
    BEN.BANK.NAME.POS    = BEN.FT.FLD.POS<1,2>
*PACS00106561-S
    BEN.OWN.OTH.BANK.POS = BEN.FT.FLD.POS<1,3>
*PACS00106561-E  ;*R22 AUTO CODE CONVERSION
    Y.BEN.CED.RNC.POS=BEN.FT.FLD.POS<1,5>
    CUS.BEN.LIST.ID=CUSTOMER.ID:'-OTHER'

    Y.REDO.BEN.ID=FIELD(CUS.BEN.LIST.ID,'*',1)
    Y.BEN.NO=R.NEW(STO.BENEFICIARY.ID)

RETURN
*---------------*
AUTO.POP.DETAILS:
*---------------*

    CALL F.READ(FN.CUS.BEN.LIST,Y.REDO.BEN.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.LIST.ERR)
    IF NOT(CUS.LIST.ERR) THEN

        LOOP

            REMOVE BEN.EACH.ID FROM R.CUS.BEN.LIST SETTING BEN.LIST.POS
        WHILE BEN.EACH.ID:BEN.LIST.POS
            ACCT.BEN.ID = FIELD(BEN.EACH.ID,"*",2)
*BEN.ID=FIELD(BEN.EACH.ID,"*",2)  ;*R22 AUTO CODE CONVERSION
            IF ACCT.BEN.ID EQ Y.BEN.NO THEN
                BEN.ID=FIELD(BEN.EACH.ID,"*",2)
                Y.BEN.ACC.NO=FIELD(BEN.EACH.ID,"*",1)
            END

        REPEAT

    END
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
            AF = STO.BENEFICIARY
            CALL STORE.END.ERROR
        END
        R.NEW(STO.FT.LOC.REF.DATA)<1,1>=BANK.CUST.NAME
        R.NEW(STO.FT.LOC.REF.DATA)<1,3>=Y.BEN.ACC.NO
        R.NEW(STO.FT.LOC.REF.DATA)<1,2>=R.BEN<ARC.BEN.LOCAL.REF,Y.BEN.CED.RNC.POS>
        R.NEW(STO.FT.LOC.REF.DATA)<1,4>=BANK.NAME
    END
RETURN
END
