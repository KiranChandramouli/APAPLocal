* @ValidationCode : MjotMTQ4OTA2Mjg3ODpDcDEyNTI6MTY4MTg5NzgxODE0MjpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 15:20:18
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
$PACKAGE APAP.TAM
SUBROUTINE S.REDO.CCRG.SUNNEL.GET.BAL(P.CUSTOMER.ID,P.RETURN)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP - Asociacion Popular de Ahorros y Prestamos.
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description: Subrutine to get the direct and income balances from credit cards. This subroutine
*      interacts with the SUNNEL interface to get this information.
*
* Linked With:
*               SERVICE      REDO.CCRG.B.EXT
*
* In Parameter:
*               P.CUSTOMER.ID    (in)  Contranct Id.
*
* Out Parameter:
*               P.RETURN     (out)  Returns balances related: 1 Direct Balance, 2 Income Receivable, 3 Balance Contingent
*               E            (out)  Message in case Error
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 17/05/2011 - ODR-2011-03-0154
*              B.5 Control of Linked Customers and Risk Groups.
*              rmondragon@temenos.com
*REM Just for compile
*--------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*19-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*19-04-2023              Samaran T                R22 Manual Code conversion                        CALL ROUTINE FORMAT MODIFIED
*-----------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*
    $INSERT I_REDO.CCRG.B.EXT.COMMON
    $INSERT I_REDO.CCRG.CONSTANT.COMMON
    $INSERT I_F.REDO.SUNNEL.PARAMETER
*

*--------------------------------------------------------------------------------------------
*


    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
    Y.DB = 0
    Y.RB = 0
    Y.CB = 0
* Parameters to process the store procedure in SUNNEL
    D.FIELDS = 'CLIENT.ID'      ;*This value corresponding to the T24.IN field from REDO.SUNNEL.METHOD application
    D.RANGE.AND.VALUE = P.CUSTOMER.ID:@VM  ;*This is the value for the field

* Get the direct balance.
    Y.ARRAY = 'T24_LIMCRED_SUNNEL.SP_TC_CUPO'       ;*Id of the REDO.SUNNEL.METHOD application
    GOSUB CALL.SUNNEL
    Y.DB  = Y.VALUE

* Get the income receivable.
    Y.ARRAY       = ''
    Y.FINAL.ARRAY = ''
    Y.ARRAY       = 'T24_LIMCRED_SUNNEL.SP_INT_VENC_60'       ;*Id of the REDO.SUNNEL.METHOD application
    GOSUB CALL.SUNNEL
    Y.RB  = Y.VALUE
*
    IF Y.ERROR THEN
        P.RETURN<1> = 'ERROR'
        P.RETURN<2> = Y.ERROR
    END ELSE
        P.RETURN<1> = Y.DB
        P.RETURN<2> = Y.RB
        P.RETURN<3> = Y.CB
    END
*
RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

    LOOP.CNT         = 1
    MAX.LOOPS        = 2
    PROCESS.GOAHEAD  = @TRUE
    Y.ARRAY          = ''
    P.RETURN         = ''
    Y.FINAL.ARRAY    = ''

    FN.SUNNEL.PARAM = 'F.REDO.SUNNEL.PARAMETER'
    F.SUNNEL.PARAM = ''
    CALL OPF(FN.SUNNEL.PARAM,F.SUNNEL.PARAM)

    CALL CACHE.READ(FN.SUNNEL.PARAM,'SYSTEM',R.SUNNEL.REC,SUNNEL.ERR)

RETURN

*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF NOT(P.CUSTOMER.ID) THEN
                    E = K.PARAMETER.IS.EMPTY : @FM : "P.CUSTOMER.ID" : @VM : "S.REDO.CCRG.SUNNEL.GET.BAL"
                    PROCESS.GOAHEAD = @FALSE
                END
        END CASE

        LOOP.CNT +=1
    REPEAT

RETURN

*--------------------------------------------------------------------------------------------
CALL.SUNNEL:
*--------------------------------------------------------------------------------------------

    IF Y.ERROR THEN
*If exists error, dont get any value from SUNNEL
        RETURN
    END

* Call store procedures from SUNNEL usen calljee
    CALL APAP.TAM.REDO.V.WRAP.SUNNEL(Y.ARRAY)   ;*R22 MANUAL CODE CONVERSION

* Get value from SUNNEL
    Y.ALL.DATA=Y.ARRAY
    CHANGE '@' TO @FM IN Y.ALL.DATA
    IF Y.ALL.DATA<1> EQ 'SUCCESS' THEN
*SUCCESS
        Y.VALUE  = Y.ALL.DATA<2>
*When SUNNEL return -1, it is that, for this customer does not exists any record in SUNNEL
        IF Y.VALUE EQ '-1' THEN
            Y.VALUE = ''
        END
    END ELSE
*FAIL
        Y.ERROR  = Y.ALL.DATA<2>
    END

RETURN

*--------------------------------------------------------------------------------------------
END
