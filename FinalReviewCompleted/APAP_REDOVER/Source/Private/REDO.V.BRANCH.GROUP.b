* @ValidationCode : MjoxMzE5NjAyNjA4OkNwMTI1MjoxNjgyNDEyMzQxNTc0OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:41
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
SUBROUTINE REDO.V.BRANCH.GROUP
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.TELLER.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : jeeva t
* PROGRAM NAME : REDO.V.BRANCH.GROUP
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*27-05-2011     jeeva T      PACS00062653    Initial Creation
* -----------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.H.MAIN.COMPANY
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.H.REASSIGNMENT
    $INSERT I_GTS.COMMON

    GOSUB INIT
    IF APPLICATION NE 'REDO.H.REASSIGNMENT' THEN
        GOSUB PROCESS
    END ELSE
        GOSUB PROCESS1
    END

RETURN
*---
INIT:
*---
    FN.REDO.H.ORDER.DETAILS = 'F.REDO.H.ORDER.DETAILS'
    F.REDO.H.ORDER.DETAILS = ''
    CALL OPF(FN.REDO.H.ORDER.DETAILS,F.REDO.H.ORDER.DETAILS)
    FN.REDO.H.MAIN.COMPANY ='F.REDO.H.MAIN.COMPANY'
    F.REDO.H.MAIN.COMPANY = ''
    CALL OPF(FN.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY)

RETURN
*-------
PROCESS:
*-------
*To validate the fields and updates the value
    Y.GROUP = COMI
    R.REDO.H.MAIN.COMPANY = ''
    CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.GROUP,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)
    IF R.REDO.H.MAIN.COMPANY THEN
        Y.CODE = R.REDO.H.MAIN.COMPANY<REDO.COM.CODE>
        Y.DES = R.REDO.H.MAIN.COMPANY<REDO.COM.DESCRIPTION>
        CHANGE @VM TO '_' IN Y.CODE
        CHANGE @VM TO '_' IN Y.DES
        T(RE.ORD.BRANCH.CODE) = "":@FM:Y.CODE
        T(RE.ORD.BRANCH.DES) = "":@FM:Y.DES
    END ELSE
        T(RE.ORD.BRANCH.CODE)<3>  = 'NOINPUT'
        T(RE.ORD.BRANCH.DES)<3>  = 'NOINPUT'
        R.NEW(RE.ORD.BRANCH.CODE) = ''
        R.NEW(RE.ORD.BRANCH.DES) = ''
    END
RETURN
*---------------------------------------------------------------------------------------
PROCESS1:
*---------------------------------------------------------------------------------------

    Y.GROUP = COMI
    CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.GROUP,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)
    IF R.REDO.H.MAIN.COMPANY THEN
        Y.CODE = R.REDO.H.MAIN.COMPANY<REDO.COM.CODE>
        Y.DES = R.REDO.H.MAIN.COMPANY<REDO.COM.DESCRIPTION>
        CHANGE @VM TO '_' IN Y.CODE
        CHANGE @VM TO '_' IN Y.DES
        T(RE.ASS.DEPT.DES) = "":@FM:Y.DES
    END ELSE
        T(RE.ASS.DEPT.DES)<3>= 'NOINPUT'
        R.NEW(RE.ASS.DEPT.DES) = ''
    END
RETURN
END
