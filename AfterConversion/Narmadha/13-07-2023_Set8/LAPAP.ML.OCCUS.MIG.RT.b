* @ValidationCode : MjoxMjk1MDAxODQ1OlVURi04OjE2ODkyNTQyMTM4NTI6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 18:46:53
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.ML.OCCUS.MIG.RT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 13-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE ;*R22 Auto Conversion - START
    $INSERT I_COMMON
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER ;*R22 Auto Conversion - END
 
    GOSUB INITIALIZE
    GOSUB READLIST
    GOSUB PROCESS
RETURN

INITIALIZE:
    FN.OCUSTOMER = 'FBNK.ST.LAPAP.OCC.CUSTOMER'
    F.OCUSTOMER = ''
    CALL OPF(FN.OCUSTOMER,F.OCUSTOMER)

RETURN

READLIST:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.OCUSTOMER : " WITH CO.CODE EQ 1"


    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)

RETURN

PROCESS:
    IF SEL.REC THEN
        DISPLAY @(1, 10) : 'Total de registros a ajustar: ' : SEL.LIST
        Y.CNT = 0
        LOOP

            REMOVE Y.OC.ID FROM SEL.REC SETTING TAG

        WHILE Y.OC.ID:TAG
            Y.CNT +=1
            CALL F.READ(FN.OCUSTOMER,Y.OC.ID,R.OCUSTOMER,F.OCUSTOMER,ERR.OCUSTOMER)
            IF R.OCUSTOMER THEN
                DISPLAY @(2, 10) : 'Proceso actual : ' : Y.CNT
                DISPLAY @(3, 10) : 'Ajustando cliente ocasional : ' : Y.OC.ID
                R.OCUSMOD = R.OCUSTOMER
                R.OCUSMOD<ST.L.OCC.CURR.NO> = R.OCUSTOMER<ST.L.OCC.RECORD.STATUS>
                R.OCUSMOD<ST.L.OCC.INPUTTER> = R.OCUSTOMER<ST.L.OCC.CURR.NO>
                R.OCUSMOD<ST.L.OCC.DATE.TIME> = R.OCUSTOMER<ST.L.OCC.INPUTTER>
                R.OCUSMOD<ST.L.OCC.AUTHORISER> = R.OCUSTOMER<ST.L.OCC.DATE.TIME>
                R.OCUSMOD<ST.L.OCC.CO.CODE> = R.OCUSTOMER<ST.L.OCC.AUTHORISER>
                R.OCUSMOD<ST.L.OCC.DEPT.CODE> = R.OCUSTOMER<ST.L.OCC.CO.CODE>
                R.OCUSMOD<ST.L.OCC.AUDITOR.CODE> = R.OCUSTOMER<ST.L.OCC.DEPT.CODE>
                CALL F.WRITE(FN.OCUSTOMER, Y.OC.ID, R.OCUSMOD)
                CALL JOURNAL.UPDATE('')
            END
        REPEAT

        DISPLAY @(4, 10) : '*** Proceso finalizado ***'
    END
RETURN
END
