* @ValidationCode : Mjo4NTQ4MjEwNzE6Q3AxMjUyOjE2ODEyODIxNTUzNjY6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:19:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.NON.CONFIRM.PAY(CHQ.DETAILS.ID)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.NON.CONFIRM.PAY
*-------------------------------------------------------------------------

* Description :This routine will change the status of selected record to
*              ISSUED

* In parameter : None
* out parameter : None
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - CONVERT TO CHANGE AND TNO TO C$T24.SESSION.NO
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.USER
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_REDO.B.NON.CONFIRM.PAY.COMMON

    GOSUB PROCESS
RETURN
************
PROCESS:
************

    R.CHQ.DETAILS=''
    CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,CHQ.DETAILS.ID,R.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,CHQ.ERR)
    R.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>='ISSUED'
    Y.CURR.NO=R.CHQ.DETAILS<ADMIN.CHQ.DET.CURR.NO>
    R.CHQ.DETAILS<ADMIN.CHQ.DET.CURR.NO>=Y.CURR.NO+1
    R.CHQ.DETAILS<ADMIN.CHQ.DET.INPUTTER>=C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME  ;*R22 AUTO CONVERSTION CONVERT TO CHANGE
    CHECK.DATE = DATE()
    R.CHQ.DETAILS<ADMIN.CHQ.DET.DATE.TIME>= OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
    R.CHQ.DETAILS<ADMIN.CHQ.DET.CO.CODE> = ID.COMPANY
    R.CHQ.DETAILS<ADMIN.CHQ.DET.AUTHORISER>=C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    R.CHQ.DETAILS<ADMIN.CHQ.DET.DEPT.CODE> =R.USER<EB.USE.DEPARTMENT.CODE>
    CALL F.WRITE(FN.REDO.ADMIN.CHQ.DETAILS,CHQ.DETAILS.ID,R.CHQ.DETAILS)
RETURN
END
