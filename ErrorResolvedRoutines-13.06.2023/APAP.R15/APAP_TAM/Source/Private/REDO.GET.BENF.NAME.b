* @ValidationCode : MjotMTY3MjQ5Mzc4OkNwMTI1MjoxNjgwNzYwMzM1ODAyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 11:22:15
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
SUBROUTINE REDO.GET.BENF.NAME(VAR.AC.ID)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.BENF.NAME
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This routine is used for Deal slip. Will return the name as per the requirement
* In parameter  :
* out parameter : Y.NAME
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 13-sept-2011      JEEVA T        PACS00127058
* 16-Feb -2012      Prabhu N       PACS00172838        Y.AMOUNT taken from AMOUNT.CREDITED.
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_System

    GOSUB OPEN.FILE
    GOSUB PROCESS.FILE


RETURN

*----------------------------------------------------------------------------------------------------
OPEN.FILE:
*----------------------------------------------------------------------------------------------------

    APPLNS = 'AZ.ACCOUNT':@FM:'ACCOUNT':@FM:'CUSTOMER':@FM:'FUNDS.TRANSFER'
    LOC.FIELDS = 'L.TYPE.INT.PAY':@VM:'BENEFIC.NAME':@VM:'BENEFIC.ACC.NO':@VM:'BENEFIC.BNK.CDE':@FM:'L.AC.PAYMT.MODE':@FM:'L.CU.TIPO.CL':@FM:'BENEFIC.NAME'
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(APPLNS,LOC.FIELDS,LOC.POS)
    POS.PAY.MDE = LOC.POS<1,1>
    POS.BENE.NAME =  LOC.POS<1,2>
    POS.BENE.AC.NO = LOC.POS<1,3>
    POS.BENE.BNK.CDE = LOC.POS<1,4>
    POS.AC.PAY.MDE = LOC.POS<2,1>
    POS.TIPO.CUS = LOC.POS<3,1>
    POS.FT.BENEF.NAME = LOC.POS<4,1>

    Y.LIST.NAME = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

RETURN

*----------------------------------------------------------------------------------------------------
PROCESS.FILE:
*----------------------------------------------------------------------------------------------------
    Y.OUT.NAME = ''
    Y.ACCOUNT.ID = FIELD(System.getVariable("CURRENT.ACCS"),"-",1)
    Y.AMOUNT =     R.NEW(FT.AMOUNT.CREDITED)
    Y.AMOUNT = Y.AMOUNT[4,LEN(Y.AMOUNT)]
    Y.AMOUNT =  TRIMB(FMT(Y.AMOUNT,'L2,#19'))
    Y.CUS.ID = R.NEW(FT.ORDERING.CUST)
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,Y.ERR)

    Y.FULL.NAME = R.NEW(FT.LOCAL.REF)<1,POS.FT.BENEF.NAME,1>
    Y.LIST.NAME = R.NEW(FT.LOCAL.REF)<1,POS.FT.BENEF.NAME,2>

    IF Y.LIST.NAME THEN
        Y.OUT.NAME = Y.FULL.NAME: ' ':Y.LIST.NAME
    END ELSE
        Y.OUT.NAME = Y.FULL.NAME
    END
    Y.LENGTH = LEN(Y.OUT.NAME)
    IF Y.LENGTH GT 65 THEN
        VAR.AC.ID = Y.OUT.NAME[1,65]:'    ':Y.AMOUNT:@VM:'                      ':Y.OUT.NAME[66,LEN(Y.OUT.NAME)]
    END ELSE
        VAR.AC.ID = FMT(Y.OUT.NAME,'L#65'):'    ':Y.AMOUNT

    END
RETURN
END
