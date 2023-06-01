* @ValidationCode : Mjo3NjQ2ODk5MjpDcDEyNTI6MTY4MzAwMTUzNzQ5MzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 May 2023 09:55:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.PASSPORT.CUST(Y.APP.VERSION)
*--------------------------------------------------------------------------------------------------------------------------------
*   DESCRIPTION :
*
*   VALIDATES CEDULA ID NUMBER AND GETS CUSTOMER NAME
*
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JOAQUIN COSTA
*
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date           Author             Reference        Description
* MAR-30-2012    J COSTA            GRUPO 7          Initial creation
* 23/05/2013     Vignesh Kumaar R   PACS00290270     Current variable issue in CURRENT.VAR.DETAILS
*-----------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
*
    $INSERT I_F.CUSTOMER
*
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_REDO.ID.CARD.CHECK.COMMON
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
    R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) = CLIENTE.APAP
    CALL System.setVariable("CURRENT.CLIENTE.APAP",CLIENTE.APAP)
*
    IF CUSTOMER.FULL.NAME THEN
        R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = CUSTOMER.FULL.NAME
        VAR.DETAILS = "PASAPORTE*" : PASSPORT.NUMBER : "*" : CUSTOMER.FULL.NAME : "*" : CUS.ID
        CALL System.setVariable("CURRENT.VAR.DETAILS",VAR.DETAILS)

* Fix for PACS00290270 [Current variable issue in CURRENT.VAR.DETAILS]

        CALL System.saveVariables ;* flush the data immediately

* End if Fix

    END
*
RETURN
*
* ==================
CHECK.PASS.NON.APAP:
* ==================
*
*   Non APAP customer PASSPORT is only allowed up on manual verification by the TELLER / USER
*
    CLIENTE.APAP       = "NO CLIENTE APAP"
    CUSTOMER.FULL.NAME = ""
    CUS.ID             = "NA"
*
    T(REDO.CUS.PRF.CUSTOMER.NAME)<3> = ''
*
RETURN
*
* ================
GET.CUSTOMER.INFO:
* ================
*
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    IF R.CUSTOMER THEN
        CLIENTE.APAP       = "CLIENTE APAP"
        CUSTOMER.FULL.NAME = R.CUSTOMER<EB.CUS.NAME.1>
    END ELSE
        GOSUB NO.CLIENTE.APAP
    END
*
RETURN
*
* ==============
NO.CLIENTE.APAP:
* ==============
*
*    Y.APP.VERSION = FIELD(VAR.VERSION,',',1)
    IF Y.APP.VERSION EQ 'FOREX' THEN
        AF              = REDO.CUS.PRF.IDENTITY.NUMBER
        ETEXT           = "EB-INVALID.IDENTITY"
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END ELSE
        GOSUB CHECK.PASS.NON.APAP
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
*
    CLIENTE.APAP       = ""
    CUSTOMER.FULL.NAME = ""
    VAR.DETAILS        = ""
    CUS.ID             = ""
*
    PASSPORT.NUMBER = COMI
*
    FN.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'
    F.CUS.LEGAL.ID  = ''
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.CUS.LEGAL.ID,F.CUS.LEGAL.ID)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                CALL F.READ(FN.CUS.LEGAL.ID,PASSPORT.NUMBER,R.CUS.LEGAL.ID,F.CUS.LEGAL.ID,CUS.LEGAL.ERR)
                IF R.CUS.LEGAL.ID THEN
                    CUS.ID = FIELD(R.CUS.LEGAL.ID,"*",2)
                    GOSUB GET.CUSTOMER.INFO
                END ELSE
                    GOSUB NO.CLIENTE.APAP
                END

        END CASE
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
