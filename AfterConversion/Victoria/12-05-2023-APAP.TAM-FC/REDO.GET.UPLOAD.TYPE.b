* @ValidationCode : MjoxMTc0MTUwOTM6Q3AxMjUyOjE2ODExMTQwMzE3NjA6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:37:11
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
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           IF CONDITION ADDED
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.GET.UPLOAD.TYPE

************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.GET.UPLOAD.TYPE
*----------------------------------------------------------

* Description   : This subroutine will get the UPLOAD TYPE
* Linked with   : none
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.EB.FILE.UPLOAD
    $INSERT I_F.REDO.CUSTOMER.PARAM
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----
INIT:
*-----
    FN.REDO.CUSTOMER.PARAM='F.REDO.CUSTOMER.PARAM'
    Y.VAR.EXT.CUSTOMER=System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION -START
        Y.VAR.EXT.CUSTOMER = ""
    END ;*AUTO R22 CODE CONVERSION - END

RETURN
*-------
PROCESS:
*-------
    CALL CACHE.READ(FN.REDO.CUSTOMER.PARAM,Y.VAR.EXT.CUSTOMER,R.REDO.CUSTOMER.PARAM,ERR)
    R.NEW(EB.UF.UPLOAD.TYPE)=R.REDO.CUSTOMER.PARAM<ACP.AC.ENTRY.PARAM>
RETURN
END
