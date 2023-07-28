* @ValidationCode : MjoxNDAxNzY3NDgxOkNwMTI1MjoxNjgyNDEyMzQ0Mjg1OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.CHECK.PASSPORT.COUNTRY

*----------------------------------------------------------------------------------------------------------------------
* DESCRIPTION :
* Note    : Passport country validation has to be made when passport number is chosen
*----------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*----------------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Sudharsan
* PROGRAM NAME : REDO.V.CHECK.PASSPORT.COUNTRY
*----------------------------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------------------------
* Date          Author             Reference       Description
* 28-Aug-2013   Sudharsan          INITIAL DRAFT   VALIDATION FOR PASSPORT COUNTRY
* 09-Sep-2013   Vignesh Kumaar R   PACS00306447    CURRENT VARIABLE ISSUE [UPDATED PACK]
*----------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                         FM TO @FM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------




    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.USER.CONTEXT

    $INSERT I_F.REDO.ID.CARD.CHECK

    FN.CUSTOMER.L.CU.PASS.NAT = 'F.CUSTOMER.L.CU.PASS.NAT'
    F.CUSTOMER.L.CU.PASS.NAT = ''
    CALL OPF(FN.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT)

    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------------------------------

    Y.ID.TYPE = R.NEW(REDO.CUS.PRF.IDENTITY.TYPE)
    Y.PASS.COUNTRY = COMI

    IF OFS$OPERATION EQ 'PROCESS' THEN
        IF Y.ID.TYPE EQ "PASAPORTE" AND NOT(Y.PASS.COUNTRY) THEN

            AF = REDO.CUS.PRF.PASSPORT.COUNTRY
            ETEXT = "AC-MAND.FLD"
            CALL STORE.END.ERROR
        END
        GOSUB SET.CURR.VARIABLE
    END

    IF OFS$OPERATION EQ 'VALIDATE' THEN

* Fix for PACS00303910 [CUSTOMER.NAME should be available for i/p when TYPE is NO CLIENTE]

        IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP'  AND R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) EQ '' THEN
            T(REDO.CUS.PRF.CUSTOMER.NAME)<3> = ''
            R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = ''
        END ELSE
            T(REDO.CUS.PRF.CUSTOMER.NAME)<3> = 'NOINPUT'
        END
    END

    GOSUB SET.CURR.VARIABLE

* End of Fix

RETURN

*----------------------------------------------------------------------------------------------------------------------
SET.CURR.VARIABLE:
*----------------------------------------------------------------------------------------------------------------------

    IF Y.ID.TYPE EQ "PASAPORTE" THEN
*   PASSPORT.CUST.ID   = "NA"
        SELECT.ID = ""
        SELECT.NR = ""
        SELECT.ERR = ""
        R.CUSTOMER.L.CU.PASS.NAT = ""
        CUSTOMER.NO = ""
        CUSTOMER.FULL.NAME = R.NEW(REDO.CUS.PRF.CUSTOMER.NAME)
        PASSPORT.NUMBER    = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
        SELECT.COMMAND = "SELECT ":FN.CUSTOMER.L.CU.PASS.NAT:" WITH @ID LIKE ":"'...":PASSPORT.NUMBER:"...'"
        CALL EB.READLIST(SELECT.COMMAND,SELECT.ID,'',SELECT.NR,SELECT.ERR)
        PASAPORTE.ID = SELECT.ID<1>
        CALL F.READ(FN.CUSTOMER.L.CU.PASS.NAT,PASAPORTE.ID,R.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT,ERR.CUSTOMER.L.CU.PASS.NAT)
        IF R.CUSTOMER.L.CU.PASS.NAT THEN
            CHANGE '*' TO @FM IN R.CUSTOMER.L.CU.PASS.NAT
            PASSPORT.CUST.ID = R.CUSTOMER.L.CU.PASS.NAT<2>
        END ELSE
            PASSPORT.CUST.ID   = "NA"
        END
        VAR.CUS.DETAILS    = "PASAPORTE*":PASSPORT.NUMBER:"*":CUSTOMER.FULL.NAME:"*":PASSPORT.CUST.ID
        R.NEW(REDO.CUS.PRF.VAR.NV.INFO) = VAR.CUS.DETAILS
    END

    IF Y.ID.TYPE EQ 'CEDULA' THEN
        CIDENT.NUMBER = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
        R.CUS.CIDENT = ''

        FN.CUSTOMER = 'F.CUSTOMER'
        F.CUSTOMER = ''
        CALL OPF(FN.CUSTOMER,F.CUSTOMER)

        FN.CUS.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
        F.CUS.CIDENT = ''
        CALL OPF(FN.CUS.CIDENT,F.CUS.CIDENT)

        CALL F.READ(FN.CUS.CIDENT,CIDENT.NUMBER,R.CUS.CIDENT,F.CUS.CIDENT,CIDENT.ERR)
        IF R.CUS.CIDENT THEN
            CUS.ID = FIELD(R.CUS.CIDENT,"*",2)
            CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
            CUSTOMER.FULL.NAME = R.CUSTOMER<EB.CUS.NAME.1>
            VAR.CUS.DETAILS = "CEDULA*" : CIDENT.NUMBER : "*" : CUSTOMER.FULL.NAME : "*" :CUS.ID
            R.NEW(REDO.CUS.PRF.VAR.NV.INFO) = VAR.CUS.DETAILS
        END
    END

    FN.EB.USER.CONTEXT = 'F.EB.USER.CONTEXT'
    F.EB.USER.CONTEXT = ''
    CALL OPF(FN.EB.USER.CONTEXT,F.EB.USER.CONTEXT)

    CALL F.READ(FN.EB.USER.CONTEXT,OPERATOR,R.EB.USER.CONTEXT,F.EB.USER.CONTEXT,EB.USER.CONTEXT.ERR)

    Y.USER.VAR = 'CURRENT.VAR.DETAILS'
    Y.USER.VAL = R.NEW(REDO.CUS.PRF.VAR.NV.INFO)
    IF Y.USER.VAL NE '' THEN
        GOSUB FLUSH.USER.VARIABLE
    END

    Y.USER.VAR = 'CURRENT.CLIENTE.APAP'
    Y.USER.VAL = R.NEW(REDO.CUS.PRF.VAR.CLIENT)
    IF Y.USER.VAL NE '' THEN
        GOSUB FLUSH.USER.VARIABLE
    END

    IF Y.FLAG THEN
*    WRITE R.EB.USER.CONTEXT ON F.EB.USER.CONTEXT, OPERATOR ;*Tus Start
        CALL F.WRITE(FN.EB.USER.CONTEXT,OPERATOR,R.EB.USER.CONTEXT)   ;* Tus End
    END

RETURN

*----------------------------------------------------------------------------------------------------------------------
FLUSH.USER.VARIABLE:
*----------------------------------------------------------------------------------------------------------------------

    LOCATE Y.USER.VAR IN R.EB.USER.CONTEXT<UCTX.NAME,1> SETTING VAR.POSS THEN
        DEL R.EB.USER.CONTEXT<UCTX.NAME,VAR.POSS>
        DEL R.EB.USER.CONTEXT<UCTX.VALUE,VAR.POSS>
    END

    R.EB.USER.CONTEXT<UCTX.NAME,-1> = Y.USER.VAR
    R.EB.USER.CONTEXT<UCTX.VALUE,-1> = Y.USER.VAL
    Y.FLAG = '1'

RETURN
*----------------------------------------------------------------------------------------------------------------------
END
