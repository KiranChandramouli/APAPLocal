* @ValidationCode : MjoxMzY2MDc1MTA0OkNwMTI1MjoxNjg2Njc2MDE5OTgxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:36:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-35</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.GET.USR.ERR.MSG(P.ERR.CODE,P.USR.MSG)
*-----------------------------------------------------------------------------
* Subroutine Type : General Routine
* Attached to     :
* Attached as     :
* Primary Purpose : Get "User Message" according to error code passed. Used on
*                   Batch/Tsa service
*
* Incoming:
* ---------
*            P.ERR.CODE
*                       <1>        Error Code (EB.ERROR>@ID)
*                       <2>        Values for variable sections
*
* Outgoing:
* ---------
*            P.USR.MSG               User Message
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 10/05/13 - hpasquel@temenos.com
*            First Version
* 14/04/14 - msthandier@temenos.com
*            Adaptation for APAP
* 13/06/2023      Santosh      R22 MANUAL CODE CONVERSION       Changed FUNCTION into SUBROUTINE and added P.USR.MSG in argument
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB INITIALIZE
    IF PROCESS.GO.AHEAD THEN
        GOSUB PROCESS
    END

*RETURN P.USR.MSG
RETURN  ;*R22 MANUAL CODE CONVERSION
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
*
    PROCESS.GO.AHEAD = P.ERR.CODE NE ""
*
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*
    ERR.MESS = P.ERR.CODE       ;* GLOBUS_EN_10000012/S
    CALL EB.GET.ERROR.MESSAGE(ERR.MESS)
    yErrExist = (ERR.MESS<8> NE "")
    ERR.MESS = ERR.MESS<1>:@FM:ERR.MESS<2> ;* GLOBUS_EN_10000012/E
*
    P.USR.MSG = ERR.MESS
*
    CALL TXT(P.USR.MSG)
*
    IF yErrExist THEN
        P.USR.MSG = P.USR.MSG     ;* : " - " : P.ERR.CODE<1>
    END
*
RETURN
*-----------------------------------------------------------------------------
END
