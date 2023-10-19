* @ValidationCode : Mjo5ODk4NzE1MjU6Q3AxMjUyOjE2ODA3Njc5MDQ2Njg6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 13:28:24
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.COMPARE.KEY
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <doc>
*
* This table is used to confirm the password
*
* author: prabhun@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*   DATE       REF                WHO       DESC
* 26/06/2011 - PACS00032519       Prabuh N Confirm the password
* 03-10-2011 - PACS00032519       PRABHU N to check 24 CHARACTER
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.INTERFACE.PARAM

    Y.KEY1=R.NEW(REDO.INT.PARAM.ENCRIP.KEY)
    Y.KEY2=R.NEW(REDO.INT.PARAM.CON.ENC.KEY)
    Y.COMP=COMPARE(Y.KEY1,Y.KEY2)
    IF Y.COMP THEN
        AF=REDO.INT.PARAM.CON.ENC.KEY
        ETEXT="EB-CHECK.PASS"
        CALL STORE.END.ERROR
    END
    IF LEN(Y.KEY1) NE '24' THEN
        AF=REDO.INT.PARAM.ENCRIP.KEY
        ETEXT="EB-CHECK.24.DIGIT"
        CALL STORE.END.ERROR

    END
RETURN
END
