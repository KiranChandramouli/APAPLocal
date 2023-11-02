* @ValidationCode : Mjo1MjUzMjYyMDE6Q3AxMjUyOjE2OTg3NTA2NzQzMjY6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:14
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
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>-86</Rating>
*-----------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion       USPLATFORM.BP file is Removed, FM ,Vm TO @FM, @VM
*

SUBROUTINE TFS.MODIFY.DENOM

*
* Subroutine Type : FIELD VAL RTN
* Attached to     : VERSION.CONTROL - T24.FUND.SERVICES
* Attached as     : FIELD.VAL.RTN
* Primary Purpose : Modifies the Denomination list in Teller transaction b
*                   transaction type entered.
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
* ----------------
*
*-------------------------------------------------------------------------
* Modification History:
*
* 01/28/08 - TPS
*            NEW API
*
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE  I_F.T24.FUND.SERVICES ; *R22 Manual code conversion 
    $INCLUDE  I_F.TFS.TRANSACTION ; *R22 Manual code conversion 
    $INSERT I_F.TELLER.DENOMINATION
    $INCLUDE  I_T24.FS.COMMON ; *R22 Manual code conversion 
    $INSERT I_F.CURRENCY.MARKET 
    $INSERT I_F.DENOM.TYPE

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
RETURN
*------------------------------------------------------------------------
PROCESS:
    GOSUB READ.VALUES
    GOSUB RETRIVE.DENOM.DATA
    GOSUB DENOM.PROCESS
    GOSUB MODIFY.DENOM.DATA

RETURN
*------------------------------------------------------------------------
*    <New Subroutines>
READ.VALUES:

    CURR = R.NEW(TFS.CURRENCY)<1,AV>
    TXN.CODE = R.NEW(TFS.TRANSACTION)<1,AV>
    CALL F.READ(FN.TT,TXN.CODE,R.TT,F.TT,TT.ERR)
    CALL GET.LOC.REF('TFS.TRANSACTION','TFS.CCY.MKT',CCY.POS)
    LOCAL.CCY.MKT = R.TT<TFS.TXN.LOCAL.REF,CCY.POS>
    CALL DBR("CURRENCY.MARKET":@FM:EB.CMA.DESCRIPTION,LOCAL.CCY.MKT,DESCRIPTION)
    CURRENCY.MARKET = UPCASE(DESCRIPTION)
RETURN
*---------------------------------------------------------------------
RETRIVE.DENOM.DATA:
    PRINT TFS$TT.DENOM(500)
    CUR.CNT = 0
    LOOP
        CUR.CNT+=1
        DENOM.CURR = TFS$TT.DENOM(CUR.CNT)<1,1>
    WHILE DENOM.CURR
        IF CURR = TFS$TT.DENOM(CUR.CNT)<1,1>[1,3] THEN
            DENOMINATION.LIST = TFS$TT.DENOM(CUR.CNT)
            BREAK
        END
    REPEAT
RETURN
*------------------------------------------------------------------
DENOM.PROCESS:
    IF DENOMINATION.LIST THEN
        LOOP.CNT = 0
        LOOP
            LOOP.CNT += 1
            DENOM.ID = DENOMINATION.LIST<1,LOOP.CNT>
        WHILE DENOM.ID
            CALL DBR('TELLER.DENOMINATION':@FM:TT.DEN.DENOM.TYPE,DENOM.ID,DENOM.TYPE)
            IF DENOM.TYPE EQ CURRENCY.MARKET THEN
                ACTUAL.DENOMINATION<-1> = DENOMINATION.LIST<1,LOOP.CNT>
                DENOM.UNITS<-1> = DENOMINATION.LIST<2,LOOP.CNT>
            END
        REPEAT
    END
RETURN
*-------------------------------------------------------------------
MODIFY.DENOM.DATA:

    IF ACTUAL.DENOMINATION THEN
        CONVERT @FM TO @VM IN ACTUAL.DENOMINATION ;*R22 Manual Conversion
        CONVERT @FM TO @VM IN DENOM.UNITS

        DENOMINATION.LIST<1> = ACTUAL.DENOMINATION
        DENOMINATION.LIST<2> = DENOM.UNITS

        TFS$TT.DENOM(CUR.CNT) = DENOMINATION.LIST
    END
RETURN
*------------------------------------------------------------------
*    </New Subroutines>
*/////////////////////////////////////////////////////////////////////////
*////////////////P R E  P R O C E S S  S U B R O U T I N E S /////////////
*/////////////////////////////////////////////////////////////////////////
INITIALISE:

    ACTUAL.DENOMINATION = '' ; DENOM.LIST = '' ; DENOM.UNITS = ''
    DENOM.TYPE = '' ; LOCAL.CCY.MKT = '' ; CCY.POS = '' ; DENOM.TYPE = ''
    PROCESS.GOAHEAD = 1

RETURN
*-------------------------------------------------------------------------
OPEN.FILES:

    FN.TD = 'F.TELLER.DENOMINATION'
    F.TD = ''
    CALL OPF(FN.TD,F.TD)

    FN.TT = 'F.TFS.TRANSACTION'
    F.TT = ''
    CALL OPF(FN.TT,F.TT)

RETURN
*-------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*
* Check for any Pre requisite conditions - like the existence of a record/
* if not, set PROCESS.GOAHEAD to 0
*
* When adding more CASEs, remember to assign the number of CASE statements
*
*
    IF MESSAGE = 'VAL' THEN
        PROCESS.GOAHEAD = 0
    END
RETURN
*-------------------------------------------------------------------------
END

