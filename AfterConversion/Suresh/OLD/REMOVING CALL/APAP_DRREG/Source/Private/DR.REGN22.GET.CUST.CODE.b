* @ValidationCode : MjotNTg2NTUyOTgwOkNwMTI1MjoxNjg0ODU2ODc5MDEwOklUU1M6LTE6LTE6Mzk5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 399
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REGN22.GET.CUST.CODE
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.SEC.TRADE

    FN.SEC.TRADE = 'F.SEC.TRADE'
    F.SEC.TRADE = ''
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
    R.SEC.TRADE = ''
    CALL GET.LOC.REF('SEC.TRADE','L.ST.CPTY',L.ST.CPTY.POS)

    CALL F.READ(FN.SEC.TRADE,COMI,R.SEC.TRADE,F.SEC.TRADE,SEC.TRADE.ERR)
    BEGIN CASE
        CASE R.SEC.TRADE<SC.SBS.BROKER.TYPE> EQ 'CO'
            CUST.ID = R.SEC.TRADE<SC.SBS.BROKER.NO>
        CASE R.SEC.TRADE<SC.SBS.BROKER.TYPE> EQ 'B'
            CUST.ID = R.SEC.TRADE<SC.SBS.LOCAL.REF,L.ST.CPTY.POS>
    END CASE

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    LOC.FLD = 'L.CU.CIDENT':@VM:'L.CU.RNC'
    CALL MULTI.GET.LOC.REF('CUSTOMER',LOC.FLD,LOC.POS)
    CIDENT.POS = LOC.POS<1,1>
    RNC.POS = LOC.POS<1,2>
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
*
    CUSTOMER.CODE = ''

    BEGIN CASE

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS> NE ''
            CUSTOMER.CODE = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS> NE ''
            CUSTOMER.CODE = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
        CASE R.CUSTOMER<EB.CUS.LEGAL.ID> NE ''
            CUSTOMER.CODE = R.CUSTOMER<EB.CUS.NATIONALITY>:' ':R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    END CASE

    COMI = CUSTOMER.CODE

RETURN

END
