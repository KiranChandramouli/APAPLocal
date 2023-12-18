* @ValidationCode : MjotNzIxNDY5OTEzOlVURi04OjE3MDI4OTc5NTY2ODM6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Dec 2023 16:42:36
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1 , I = I.VAR
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION        CALL method format changed
SUBROUTINE REDO.COL.EXTRACT.CREDIT.2(P.PARAGRAPH.IN, P.ACCOUNT.ID, P.AA.ID, P.GET.CREDIT.GRANTED, P.GET.AA.CUSTOMER, P.PROCESS.ITEMS.DETAILS)
*-----------------------------------------------------------------------------
* Name : REDO.COLLECTOR.EXTRACT.TO.CREDIT.2
*      - paragraph GET.CREDIT.GRANTED, get TERM AMOUNT data
*      - paragraph GET.AA.CUSTOMER, get AA customer details
*      - paragraph PROCESS.ITEMS.DETAIL, get insurances amounts
*------------------------------------------------------------------------------
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package REDO.COL
*
* @Parameters:
* ----------------------------------------------------------------------------
*             P.PARAGRAPH.IN            (in)  Paragraph to execute
*             P.ACCOUNT.ID              (in)  Account Id
*             P.AA.ID                   (in)  Arrangement Id
*             P.GET.CREDIT.GRANTED      (out) Out variables from GET.CREDIT.GRANTED parragraph
*             P.GET.AA.CUSTOMER         (out) Out variables from GET.AA.CUSTOMER parragraph
*             P.PROCESS.ITEMS.DETAIL    (out) Out variables from PROCESS.ITEMS.DETAIL parragraph
* ----------------------------------------------------------------------------
*             E               (out) The message error
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.COLLATERAL
*
    $INSERT I_REDO.COL.CUSTOMER.COMMON
    $INSERT I_REDO.COL.EXTRACT.CREDIT.COMMON
    $USING APAP.REDOSRTN
*
*-----------------------------------------------------------------------------

    Y.PROCESS.DATE = C.REPORT.PROCESS.DATE          ;* R.DATES(EB.DAT.LAST.WORKING.DAY) ;* TODAY

    BEGIN CASE
        CASE P.PARAGRAPH.IN EQ "GET.CREDIT.GRANTED"
            GOSUB GET.CREDIT.GRANTED
        CASE P.PARAGRAPH.IN EQ "GET.AA.CUSTOMER"
            GOSUB GET.AA.CUSTOMER
        CASE P.PARAGRAPH.IN EQ "PROCESS.ITEMS.DETAIL"
            GOSUB PROCESS.ITEMS.DETAIL
        CASE 1
            E = "PARAGRAPH & NOT IMPLEMENTED" : @FM : P.PARAGRAPH.IN
    END CASE
RETURN

*-----------------------------------------------------------------------------
GET.CREDIT.GRANTED:
*-----------------------------------------------------------------------------

    Y.TMPCREDITOMONTOAPERTURA = ""
*<< PACS00169639
    idPropertyClass = "TERM.AMOUNT"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        E = returnError
        RETURN
    END
    R.AA.TERM = RAISE(returnConditions)
*>> PACS00169639

*    Y.TMPCREDITOMONTOAPERTURA = R.AA.TERM<AA.AMT.AMOUNT>
    P.GET.CREDIT.GRANTED = ""
    P.GET.CREDIT.GRANTED<1> = R.AA.TERM<AA.AMT.AMOUNT>

    Y.L.AA.COL = R.AA.TERM<AA.AMT.LOCAL.REF,Y.AA.TERM.L.AA.COL,1>

    IF Y.L.AA.COL NE "" THEN
        CALL F.READ(FN.COLLATERAL, Y.L.AA.COL, R.COLLATERAL, F.COLLATERAL, YERR)
        IF YERR THEN
            E = yRecordNotFound : @FM : Y.L.AA.COL : @VM : "F.COLLATERAL"
            RETURN
        END
        P.GET.CREDIT.GRANTED<2> = R.COLLATERAL<COLL.DESCRIPTION>
        P.GET.CREDIT.GRANTED<3> = CHANGE(R.COLLATERAL<COLL.DESCRIPTION>, @VM, " ")[1,500]
        P.GET.CREDIT.GRANTED<4> = R.COLLATERAL<COLL.COUNTRY>
        P.GET.CREDIT.GRANTED<5> = R.COLLATERAL<COLL.NOMINAL.VALUE>
    END

RETURN
*-----------------------------------------------------------------------------
GET.AA.CUSTOMER:
*-----------------------------------------------------------------------------
*<< PACS00169639
    idPropertyClass = "CUSTOMER"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        E = returnError
        RETURN
    END
    R.AA.CUSTOMER = RAISE(returnConditions)
*>> PACS00169639
    P.GET.AA.CUSTOMER = R.AA.CUSTOMER<AA.CUS.LOCAL.REF,Y.AA.CUS.L.AA.AFF.COM>[1,400]
    P.GET.AA.CUSTOMER<2> = R.AA.CUSTOMER<AA.CUS.LOCAL.REF,Y.AA.CUS.L.AA.AFF.COM>[1,400]

RETURN

*-----------------------------------------------------------------------------
*    Get AA amount details by item
*             TMPCREDITOMONTOSEGUROVIDAVIGEN
*             TMPCREDITOMONTOSEGUROVIDAVENCI
*             TMPCREDITOMONTOSEGUROFISICOVIG
*             TMPCREDITOMONTOSEGUROFISICOVEN
*             TMPCREDITOMONTOVIGENTEOTROS
*             TMPCREDITOMONTOMOROSOOTROS
PROCESS.ITEMS.DETAIL:
*-----------------------------------------------------------------------------

    Y.AA.BALANCE.LIST = ""
    Y.AA.BALANCE.LIST<1> = "ACCSEGPROPIEDADPR" : @VM : "ACCSEGVIDAPR"    ;*TMPCREDITOMONTOSEGUROVIDAVIGEN
    Y.AA.BALANCE.LIST<2> = "DUESEGPROPIEDADPR" : @VM : "DUESEGVIDAPR"    ;*TMPCREDITOMONTOSEGUROVIDAVENCI
    Y.AA.BALANCE.LIST<3> = "ACC" : CHANGE(C.AA.SEGUROS.CHARGES.LIST, @FM, @VM : "ACC")        ;*TMPCREDITOMONTOSEGUROFISICOVIG
    Y.AA.BALANCE.LIST<4> = "DUE" : CHANGE(C.AA.SEGUROS.CHARGES.LIST, @FM, @VM : "DUE")        ;*TMPCREDITOMONTOSEGUROFISICOVEN
    Y.AA.BALANCE.LIST<5> = "ACCPRADMSEGENDOSO"      ;*TMPCREDITOMONTOVIGENTEOTROS = ACCPRADMSEGENDOSO + TMPCREDITOMONTOSEGUROVIDAVIGEN
    Y.AA.BALANCE.LIST<6> = "GRCSEGPROPIEDADPR" : @VM : "DELSEGPROPIEDADPR" : @VM : "NABSEGPROPIEDADPR" : @VM
    Y.AA.BALANCE.LIST<6> := "GRCSEGVIDAPR" : @VM : "DELSEGVIDAPR" : @VM : "NABSEGVIDAPR" : @VM
    Y.AA.BALANCE.LIST<6> := "GRCPRADMSEGENDOSO" : @VM : "DELPRADMSEGENDOSO" : @VM : "NABPRADMSEGENDOSO"

*APAP.REDOSTRN.REDO.S.GET.PERIOD.AMTS(P.ACCOUNT.ID, Y.PROCESS.DATE, Y.PROCESS.DATE, Y.AA.BALANCE.LIST, Y.OUT.AA.AMOUNT.LIST)
    APAP.REDOSRTN.redoSGetPeriodAmts(P.ACCOUNT.ID, Y.PROCESS.DATE, Y.PROCESS.DATE, Y.AA.BALANCE.LIST, Y.OUT.AA.AMOUNT.LIST);* R22 Manual conversion - CALL method format changed
 
    P.PROCESS.ITEMS.DETAILS    = Y.OUT.AA.AMOUNT.LIST<1,1>
    P.PROCESS.ITEMS.DETAILS<2> = Y.OUT.AA.AMOUNT.LIST<2,1>
    P.PROCESS.ITEMS.DETAILS<3> = Y.OUT.AA.AMOUNT.LIST<3,1>
    P.PROCESS.ITEMS.DETAILS<4> = Y.OUT.AA.AMOUNT.LIST<4,1>
    P.PROCESS.ITEMS.DETAILS<5> = Y.OUT.AA.AMOUNT.LIST<5,1>
    P.PROCESS.ITEMS.DETAILS<6> = Y.OUT.AA.AMOUNT.LIST<6,1> + Y.OUT.AA.AMOUNT.LIST<1,1>

    FOR I.VAR=1 TO 6
        IF P.PROCESS.ITEMS.DETAILS<I.VAR> EQ "" THEN
            P.PROCESS.ITEMS.DETAILS<I.VAR> = 0
        END
    NEXT I.VAR
RETURN
*-----------------------------------------------------------------------------
ARR.CONDITIONS:
*-----------------------------------------------------------------------------
    ArrangementID = P.AA.ID ; idProperty = ''; effectiveDate = Y.PROCESS.DATE; returnIds = ''; R.CONDITION =''; returnConditions = ''; returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
RETURN
*-----------------------------------------------------------------------------
END
