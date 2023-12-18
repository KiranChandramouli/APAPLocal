* @ValidationCode : MjotMTkzOTkwNTk5NDpDcDEyNTI6MTcwMjYzMTYyNzM2MzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 Dec 2023 14:43:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
*14/12/2023       Suresh                      R22 Manual Conversion      CALL routine format modified

*----------------------------------------------------------------------------------------

 


*-----------------------------------------------------------------------------
SUBROUTINE DR.REGN22.GET.CUST.CODE
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.SEC.TRADE
    
    
    $USING EB.LocalReferences ;*R22 Manual Conversion

    FN.SEC.TRADE = 'F.SEC.TRADE'
    F.SEC.TRADE = ''
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
    R.SEC.TRADE = ''
*  CALL GET.LOC.REF('SEC.TRADE','L.ST.CPTY',L.ST.CPTY.POS)
    EB.LocalReferences.GetLocRef('SEC.TRADE','L.ST.CPTY',L.ST.CPTY.POS) ;*R22 Manual Conversion

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
