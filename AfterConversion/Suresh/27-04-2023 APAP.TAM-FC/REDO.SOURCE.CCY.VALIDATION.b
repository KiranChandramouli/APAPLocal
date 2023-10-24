$PACKAGE APAP.TAM
* @ValidationCode : Mjo2NTE2NTc2MzE6Q3AxMjUyOjE2ODEzODEzODM5ODI6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 15:53:03
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

SUBROUTINE REDO.SOURCE.CCY.VALIDATION
***********************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.SOURCE.CCY.VALIDATION
***********************************************************************************
*Description: This routine is to validate the destination currency is DOP when
* source currency is DOP
*****************************************************************************
*linked with: NA
*In parameter: NA
*Out parameter: REDO.VISA.STLMT.FILE.PROCESS
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*06.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CURRENCY
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.REDO.VISA.STLMT.05TO37


    IF ERROR.MESSAGE NE '' THEN
        RETURN
    END

    GOSUB PROCESS
RETURN

*******
PROCESS:
********
    DST.CURRENCY=TRIM(R.REDO.STLMT.LINE<VISA.SETTLE.DEST.CCY.CODE>)
    SRC.CURRENCY=TRIM(Y.FIELD.VALUE)

    IF NUM(DST.CURRENCY)  AND NUM(SRC.CURRENCY) THEN

        DST.CURRENCY=DST.CURRENCY*1
        SRC.CURRENCY=SRC.CURRENCY*1

        IF DST.CURRENCY EQ '' OR SRC.CURRENCY EQ '' OR DST.CURRENCY EQ 0 OR SRC.CURRENCY EQ 0 THEN

            ERROR.MESSAGE='INVALID.CURRENCY'

            RETURN
        END
    END ELSE

        ERROR.MESSAGE='INVALID.CURRENCY'

        RETURN
    END



    Y.CCY.NUM.CODE=C$R.LCCY<EB.CUR.NUMERIC.CCY.CODE>

    IF Y.FIELD.VALUE EQ Y.CCY.NUM.CODE THEN
        IF Y.CCY.NUM.CODE NE R.REDO.STLMT.LINE<VISA.SETTLE.DEST.CCY.CODE> THEN
            ERROR.MESSAGE='INVALID.CURRENCY'
        END
    END ELSE

        IF R.REDO.STLMT.LINE<VISA.SETTLE.DEST.CCY.CODE> NE '840' THEN
            ERROR.MESSAGE='INVALID.CURRENCY'
        END
    END


RETURN

END
