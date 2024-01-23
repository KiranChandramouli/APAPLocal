* @ValidationCode : Mjo5MDYyMzcwOTc6Q3AxMjUyOjE3MDQzNzA4ODgzODk6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Jan 2024 17:51:28
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.NON.CONFIRM.PAY.LOAD
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.NON.CONFIRM.PAY.LOAD
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.NON.CONFIRM.PAY

* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 AUTO Conversion    IDVAR Variable Changed
*-------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_REDO.B.NON.CONFIRM.PAY.COMMON
 
    FN.REDO.ADMIN.CHQ.PARAM='F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM=''
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

    FN.REDO.ADMIN.CHQ.DETAILS='F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS=''
    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)

*CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,'SYSTEM',R.CHQ.PARAM,ERR)
    IDVAR.1 = 'SYSTEM' ;* R22 AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,IDVAR.1,R.CHQ.PARAM,ERR);* R22 AUTO CONVERSION

    Y.UCSP.VALIDITY = R.CHQ.PARAM<ADMIN.CHQ.PARAM.UCSP.VALIDITY>

    LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)

    F.B.DATE="-":Y.UCSP.VALIDITY:"W"
    CALL CDT('',LAST.WORK.DATE,F.B.DATE)
    BEFORE.X.DAYS =LAST.WORK.DATE
RETURN
END
