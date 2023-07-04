* @ValidationCode : MjoxNzMyMTE5MTA6Q3AxMjUyOjE2ODE5Nzk1OTU1NTI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.E.SDB.SORT(SDB.OUT, SDB.IN)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    SDB.COMPANY = FIELD(SDB.IN, '.', 1,1)
    SDB.TYPE = FIELD(SDB.IN, '.', 2,1)
    SDB.NUMBER = FIELD(SDB.IN, '.', 3,1)
    SDB.NUMBER = FMT(SDB.NUMBER, "5'0'R")

    SDB.OUT = SDB.COMPANY:".":SDB.TYPE:".":SDB.NUMBER

RETURN

END
