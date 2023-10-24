* @ValidationCode : Mjo4MjkxMTg1MjA6Q3AxMjUyOjE2ODI0MjEzMDU2MzY6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:45:05
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
SUBROUTINE REDO.GET.ARRANGEMENT.STATUS.LOAD
*DESCRIPTION:
*------------
* This is the COB routine for the B51 development and this is Load routine
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 02 Sep 2010    Ravikiran AV              B.51                  Initial Creation
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.GET.ARRANGEMENT.STATUS.COMMON

*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
MAIN.LOGIC:

    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.FIELDS

RETURN
*------------------------------------------------------------------------------------------------------------------
*List of files to be opened
*
OPEN.FILES:

    FN.AA.ARR.OVERDUE = 'F.AA.ARR.OVERDUE'
    F.AA.ARR.OVERDUE = ''
    CALL OPF(FN.AA.ARR.OVERDUE, F.AA.ARR.OVERDUE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

RETURN
*------------------------------------------------------------------------------------------------------------------
* Get the position of the Local fields
*
GET.LOCAL.FIELDS:

    LOC.REF.APP = "AA.ARR.OVERDUE":@FM:"ACCOUNT"
    LOC.REF.FIELDS = 'L.LOAN.STATUS.1':@FM:'L.LOAN.STATUS'

    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELDS,LOC.REF.POS)

    Y.OD.LOAN.STATUS.POS = LOC.REF.POS<1,1>
    Y.AC.LOAN.STATUS.POS = LOC.REF.POS<2,1>

RETURN
*------------------------------------------------------------------------------------------------------------------
END
