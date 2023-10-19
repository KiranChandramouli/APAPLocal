* @ValidationCode : MjotMjA0ODgxMjAzNjpDcDEyNTI6MTY4NTUzNjA0NDkzMDp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:57:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.NO.UNICO
******************************************************************************************************************
*Company Name : Asociaciopular de Ahorros y Pramos Bank
*Developed By : P.ANAND(anandp@temenos.com)
*Date : 26.10.2009
*Program Name : REDO.V.VAL.NO.UNICO
*Reference Number : ODR-2009-10-0807
*------------------------------------------------------------------------------------------------------------------

*Description : This subroutine validates the customer's age and check whether the customer is major or a minor
*Linked With : This routine has to be attached as an input routine to the versions of CUSTOMER,REDO.OPEN.CL.MINOR.TEST
* CUSTOMER,REDO.MOD.CL.MINOR.TEST

*In Parameter : -NA-
*Out Parameter : -NA-
*------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                          FM TO @FM
*17-04-2023              Samaran T                R22 Manual Code conversion                         CALL ROUTINE FORMAT MODIFIED
*-----------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT JBC.h
    $USING APAP.REDOSRTN
*------------------------------------------------------------------------------------------------------------------

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-------------------------------------------------------------------------------------------------------------------
INIT:
*****
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
RETURN
*-------------------------------------------------------------------------------------------------------------------
OPEN.FILES:
***********
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN
*-------------------------------------------------------------------------------------------------------------------
PROCESS:
********
* L.CU.NOUNICO should accept only 11 characters
* If the length of the variable is not equal to 11 characters,
* then set the ETEXT common variable to the error code, EB-REDO.INVALID.DOC.FORMAT
* Then call APAP.TAM.REDO.S.CALC.CHECK.DIGIT subroutine.If the returned value is FAIL, then set ETEXT as EB-REDO.INCORRECT.CHECKDIGIT

    Cedule = "padrone$":COMI
    Param1 = "com.padrone.ws.util.MainClass"
    Param2 = "callPadrone"
    Param3 = Cedule
    Ret = ""
    ACTIVATION = "APAP_PADRONES_WEBSERVICES"
    INPUT_PARAM=Cedule
    ERROR.CODE = CALLJEE(ACTIVATION,INPUT_PARAM)

    IF NOT(ERROR.CODE) THEN
        Ret = INPUT_PARAM
        GOSUB PADRONE.CHECK
    END

    IF FLAG NE '1' THEN
        CALL GET.LOC.REF('CUSTOMER','L.CU.NOUNICO',REF.POS)
        Y.L.CU.NOUNICO = COMI
        Y.LEN.L.CU.NOUNICO = LEN(Y.L.CU.NOUNICO)
        IF Y.L.CU.NOUNICO NE '' THEN
            IF Y.LEN.L.CU.NOUNICO NE 11 THEN
                GOSUB CHECK.COUNT
            END ELSE
                CHECK.NUMERIC = NUM(Y.L.CU.NOUNICO)
                IF CHECK.NUMERIC EQ 1 THEN
                    APAP.REDOSRTN.redoSCalcCheckDigit(Y.L.CU.NOUNICO)    ;*R22 MANUAL CODE CONVERSION
                END ELSE
                    GOSUB CHECK.COUNT
                END
            END
        END
        IF Y.L.CU.NOUNICO EQ 'FAIL' THEN
            AF = EB.CUS.LOCAL.REF
            AV = REF.POS
            ETEXT = 'EB-REDO.INCORRECT.CHECK.DIGIT'
            CALL STORE.END.ERROR
        END
    END

RETURN
*-------------------------------------------------------------------------------------------------
PADRONE.CHECK:
*-------------------------------------------------------------------------------------------------
    VAR.NAME = Ret
    CHANGE '$' TO '' IN VAR.NAME
    CHANGE '#' TO @FM IN VAR.NAME
    VAL.NAME = VAR.NAME<1>
    CHANGE ':' TO @FM IN VAL.NAME
    IF VAL.NAME<1> EQ 'SUCCESS' THEN
        IF VAL.TEXT EQ '' THEN
            APELLIDOS = VAR.NAME<2>
            FECHANACIMIENTO = VAR.NAME<3>
* NOMBRE = VAR.NAME<5>
            NOMBRE = VAR.NAME<4>
* IMAGEPATH=VAR.NAME<8>
            IMAGEPATH=VAR.NAME<5>
            SLASHC=DCOUNT(IMAGEPATH,'/')
            IMAGENAME=FIELD(IMAGEPATH,'/',SLASHC)
            C$SPARE(500) = "SUCCESS"
            FLAG = '1'
        END ELSE
            FLAG = '2'
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------
CHECK.COUNT:
*-------------------------------------------------------------------------------------------------------------------
    AF = EB.CUS.LOCAL.REF
    AV = REF.POS
    ETEXT = 'EB-REDO.INVALID.DOC.FORMAT'
    CALL STORE.END.ERROR
RETURN
*---------------------------------------------------------------------------------------------------------------------
END
