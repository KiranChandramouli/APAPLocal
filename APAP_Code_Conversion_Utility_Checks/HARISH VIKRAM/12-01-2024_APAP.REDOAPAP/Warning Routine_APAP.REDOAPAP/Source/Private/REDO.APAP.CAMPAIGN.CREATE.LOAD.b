* @ValidationCode : MjotMTA5NjMyOTY2NDpDcDEyNTI6MTcwMzU4NTA2NTQyMjpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Dec 2023 15:34:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CAMPAIGN.CREATE.LOAD
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep P
* Program Name  : REDO.APAP.CAMPAIGN.CREATE.LOAD
* ODR NUMBER    : ODR-2010-08-0228
*---------------------------------------------------------------------------------
* Description : This is a .load routine to load the required files
* In parameter : None
* out parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO          REFERENCE         DESCRIPTION
* 25-08-2010     Pradeep P    ODR-2010-08-0228    Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*22-12-2023      HARISHVIKRAM                 R22 Manual conversion        ID.VAR Initialised
*----------------------------------------------------------------------------------------



* ----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.CR.OPPORTUNITY
    $INSERT I_REDO.APAP.CAMPAIGN.CREATE.COMMON

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
*----
    FN.CUST = 'F.CUSTOMER'
    F.CUST = ''

    FN.BAT = 'F.BATCH'
    F.BAT = ''

    FN.CR.OPP = 'F.CR.OPPORTUNITY'
    F.CR.OPP = ''

    FN.REDO.APAP.CAM.PATH = 'F.REDO.APAP.CAMPAIGN.PATH'
    F.REDO.APAP.CAM.PATH = ''

    FN.PATH = ''
    F.PATH = ''

    FLD.POS = ''

    Y.FINAL.ARRAY = ''

RETURN
*
OPENFILES:
*---------
    CALL OPF(FN.CUST,F.CUST)
    CALL OPF(FN.BAT,F.BAT)
    CALL OPF(FN.CR.OPP,F.CR.OPP)
    CALL OPF(FN.REDO.APAP.CAM.PATH,F.REDO.APAP.CAM.PATH)

RETURN
*
PROCESS:
*-------
    Y.LOC.FIELDS = "L.CU.TEL.AREA":@VM:"L.CU.TEL.NO":@VM:"L.CU.TEL.TYPE"
    CALL MULTI.GET.LOC.REF("CUSTOMER",Y.LOC.FIELDS,FLD.POS)
    ID.VAR = "BNK/REDO.B.CAMPAIGN.FILE.GEN"
*    CALL F.READ(FN.BAT,"BNK/REDO.B.CAMPAIGN.FILE.GEN",R.BAT.REC,F.BAT,Y.B.ERR)
    CALL F.READ(FN.BAT,ID.VAR,R.BAT.REC,F.BAT,Y.B.ERR)                          ;*R22 Manual Conversion
    Y.DAT = R.BAT.REC<BAT.DATA>

    Y.TEL.AREA.POS = FLD.POS<1,1>
    Y.TEL.NO.POS = FLD.POS<1,2>
    Y.TEL.TYPE.POS = FLD.POS<1,3>

    SYS.DATE.NOW = OCONV(DATE(),"D-")
    SYS.DATE.NOW = SYS.DATE.NOW[7,4]:SYS.DATE.NOW[1,2]:SYS.DATE.NOW[4,2]
    CURRENT.TIME = TIMEDATE()[1,2]:TIMEDATE()[4,2]

    FILE.NAME = Y.DAT:SYS.DATE.NOW:CURRENT.TIME:'.txt'

RETURN
END
