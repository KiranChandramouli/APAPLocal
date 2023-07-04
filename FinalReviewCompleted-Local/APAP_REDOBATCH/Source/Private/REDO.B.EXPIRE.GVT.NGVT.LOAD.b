* @ValidationCode : MjoxODI5OTQ5MjA4OkNwMTI1MjoxNjgwNzkwMTA4Nzk2OklUU1M6LTE6LTE6MjkyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 292
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.EXPIRE.GVT.NGVT.LOAD
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.EXPIRE.GVT.NGVT.LOAD
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.EXPIRE.GVT.NGVT

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY

    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_REDO.B.EXPIRE.GVT.NGVT.COMMON

    FN.REDO.ADMIN.CHQ.PARAM='F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM=''
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

    FN.REDO.ADMIN.CHQ.DETAILS='F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS=''
    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,'SYSTEM',R.CHQ.PARAM,ERR)
    Y.EXPIRE.MONTHS = R.CHQ.PARAM<ADMIN.CHQ.PARAM.EXPIRE.MONTHS>
    Y.EXP.MONTH = Y.EXPIRE.MONTHS:'M'

*Government is taken from the second multivalue set
    GVMNT.ACCT = R.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,2>

*Non-Government is taken from the first multivalue set
    NON.GVMNT.ACCT = R.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,1>

*    LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    LAST.WORK.DATE = TODAY      ;* Fix for PACS00319443

    Y.COUNTRY = R.COMPANY(EB.COM.LOCAL.COUNTRY)
    RETURN.DATE =''
    RETURN.CODE = ''
    RETURN.DISPLACEMENT = ''

*    CALL WORKING.DAY('',LAST.WORK.DATE, '-', Y.EXP.MONTH, 'B', Y.COUNTRY, '', RETURN.DATE, RETURN.CODE, RETURN.DISPLACEMENT)
*    BEFORE.X.MNTHS = RETURN.DATE

*--- Fix HD1052809 Start

    CALL CALENDAR.DAY(LAST.WORK.DATE,'-',Y.EXP.MONTH)

    BEFORE.X.MNTHS = Y.EXP.MONTH

*--- Fix HD1052809 End

RETURN
END
