* @ValidationCode : Mjo1MDA3MzQxNDk6Q3AxMjUyOjE2ODU5NTE5MzkwNTY6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:28:59
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

$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.TXN.REFER
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at Auth Level for the Following version of
* AA.ARRANGEMENT.ACTIVITY,APAP. This Routine is used store the arrangement id into the
* local template REDO.CREATE.ARRANGEMENT
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
* Linked : AA.ARRANGEMENT.ACTIVITY
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Arulprakasam P
* PROGRAM NAME : REDO.V.AUTH.TXN.REFER
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 10.11.2010      Arulprakasam P    ODR-2010-11-0067  INITIAL CREATION
* 2011-01-11      hpasquel                            Save a CONCAT.FILE with the relation between REDO.CREATE.ARRANGEMENT and its ARRANGENT.ID
*                                                     Update STATUS on REDO.CREATE.ARRANGEMENT
*    DATE                   WHO               REFERENCE
* 19-05-2023         Conversion Tool    R22 Auto Conversion - No changes
* 19-05-2023          ANIL KUMAR B      R22 Manual Conversion - CR TO FC AND CR.REC.STATUS TO FC.RECORD.STATUS
* -----------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
$INSERT I_F.REDO.CREATE.ARRANGEMENT

GOSUB OPENFILES
GOSUB PROCESS
RETURN

**********
OPENFILES:
**********

FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
F.REDO.CREATE.ARRANGEMENT = ''
CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

LOC.REF.APPLICATION = 'AA.ARRANGEMENT.ACTIVITY'
LOC.REF.FIELDS = 'TXN.REF.ID'
LOC.REF.POS = ''

* << PP 2011-01-11
FN.REDO.CRE.ARR.CONCAT = 'F.REDO.CRE.ARR.CONCAT'
F.REDO.CRE.ARR.CONCAT = ''
CALL OPF(FN.REDO.CRE.ARR.CONCAT,F.REDO.CRE.ARR.CONCAT)
* >>

RETURN

********
PROCESS:
********

CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
TXN.REF.ID.POS = LOC.REF.POS<1,1>
Y.TXN.ID = R.NEW(AA.ARR.ACT.LOCAL.REF)<1,TXN.REF.ID.POS>
Y.ARRANGEMENT.ID = R.NEW(AA.ARR.ACT.ARRANGEMENT)

*CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,Y.TXN.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,REDO.CREATE.ARRANGEMENT.ERR)
CALL F.READU(FN.REDO.CREATE.ARRANGEMENT,Y.TXN.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,REDO.CREATE.ARRANGEMENT.ERR,'');* R22 AUTO CONVERSION

*BEGIN / ADDED BY TAM.BP MARCELO G - 07/01/2011
*Y.IMG.TYPES = R.REDO.CREATE.ARRANGEMENT<REDO.CR.IMG.TYPE>
*Y.IMG.IDS = R.REDO.CREATE.ARRANGEMENT<REDO.CR.IMG.ID>
Y.IMG.TYPES = R.REDO.CREATE.ARRANGEMENT<REDO.FC.IMG.TYPE>   ;*R22 MANUAL CON CR TO FC
Y.IMG.IDS = R.REDO.CREATE.ARRANGEMENT<REDO.FC.IMG.ID>     ;*R22 MANUAL CON CR TO FC
Y.COUNT.IMG = DCOUNT(Y.IMG.IDS,@VM)
* Create registers in IM.DOCUMENT.IMAGE and IM.DOCUMENT.UPDATE

FOR Y.I = 1 TO Y.COUNT.IMG
*Y.IMG.TYPES = R.REDO.CREATE.ARRANGEMENT<REDO.CR.IMG.TYPE, Y.I>
*Y.IMG.IDS = R.REDO.CREATE.ARRANGEMENT<REDO.CR.IMG.ID, Y.I>
Y.IMG.TYPE = R.REDO.CREATE.ARRANGEMENT<REDO.FC.IMG.TYPE, Y.I>  ;*R22 MANUAL CON CR TO FC
Y.IMG.ID = R.REDO.CREATE.ARRANGEMENT<REDO.FC.IMG.ID, Y.I>    ;*R22 MANUAL CON CR TO FC
*IM.DOCUMENT.IMAGE
Y.VERSION.NAME = 'IM.DOCUMENT.IMAGE,APAP'
Y.OFS.BODY =  ',,IMAGE.TYPE=':Y.IMG.TYPE:',IMAGE.APPLICATION=AA.ARRANGEMENT,IMAGE.REFERENCE=':Y.ARRANGEMENT.ID:','
Y.OFS.BODY := 'SHORT.DESCRIPTION=':Y.IMG.ID:',DESCRIPTION=':Y.TXN.ID:',MULTI.MEDIA.TYPE:1:1=IMAGE'
GOSUB PROCESS.OFS.MESSAGE
NEXT Y.I
* << PP 2011-01-11
R.NEW(REDO.FC.RECORD.STATUS) = '1'    ;*R22 MANUAL CON CR TO FC.RECORD.STATUS
* >>

* PP 2011-01-11    R.REDO.CREATE.ARRANGEMENT<REDO.CR.ARRANGEMENT.ID> = Y.ARRANGEMENT.ID
CALL F.WRITE(FN.REDO.CREATE.ARRANGEMENT,Y.TXN.ID,R.REDO.CREATE.ARRANGEMENT)
*END / ADDED BY TAM.BP MARCELO G - 07/01/2011

* << PP 2011-01-11
REDO.CRE.ARR.CONCAT = Y.TXN.ID
CALL F.WRITE(FN.REDO.CRE.ARR.CONCAT, Y.ARRANGEMENT.ID, R.REDO.CRE.ARR.CONCAT)
* >>
RETURN


******************
PROCESS.OFS.MESSAGE:
******************
*BEGIN / ADDED BY TAM.BP MARCELO G - 07/01/2011
VERSION.NAME = Y.VERSION.NAME
OFS.USER.PWD = "/"
OFS.MSG.HEADER = VERSION.NAME:'/I/PROCESS/,':OFS.USER.PWD:'//0'
OFS.BODY = Y.OFS.BODY
OFS.MSG = OFS.MSG.HEADER:OFS.BODY

OFS.SRC<1> = 'RCA'
OFS.RESP = ''
TXN.COMMIT = ''

OFS.STR = OFS.MSG
OFS.MSG.IDD = ''
OFS.SRC = 'APAP.B.180.OFS'
OPTIONS = ''

CALL OFS.POST.MESSAGE(OFS.STR,OFS.MSG.IDD,OFS.SRC,OPTIONS)
*END  / ADDED BY TAM.BP MARCELO G - 07/01/2011
RETURN


END
