* @ValidationCode : MjotODQ2ODk2NjkwOkNwMTI1MjoxNjg2NjU2MTg1ODY4OklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jun 2023 17:06:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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

RETURN P.USR.MSG
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
