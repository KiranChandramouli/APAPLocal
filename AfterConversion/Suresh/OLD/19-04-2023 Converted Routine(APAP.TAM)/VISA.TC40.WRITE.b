* @ValidationCode : MjoyNzcwNzE4MjU6Q3AxMjUyOjE2ODE4OTA0ODYwODc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:18:06
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
SUBROUTINE VISA.TC40.WRITE(Y.ID,R.ARRAY)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: VISA.TC40.WRITE
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is write the VISA.TC40.WRITE with Audit Fields



*IN PARAMETER: R.ARRAY
*OUT PARAMETER: NA
*LINKED WITH: VISA.TC40.OUT.FILE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*1.12.2010  H GANESH     ODR-2010-08-0469  INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          TNO TO C$T24.SESSION.NO
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.VISA.TC40.OUT.FILE


    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------


    FN.VISA.TC40.OUT.FILE='F.VISA.TC40.OUT.FILE'
    F.VISA.TC40.OUT.FILE=''
    CALL OPF(FN.VISA.TC40.OUT.FILE,F.VISA.TC40.OUT.FILE)


    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME
    CHECK.DATE = DATE()
    R.ARRAY<VISA.TC40.RECORD.STATUS>=''
    R.ARRAY<VISA.TC40.DATE.TIME>=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
    R.ARRAY<VISA.TC40.CURR.NO>='1'
    R.ARRAY<VISA.TC40.AUTHORISER>=C$T24.SESSION.NO:'_':OPERATOR
    R.ARRAY<VISA.TC40.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
    R.ARRAY<VISA.TC40.CO.CODE>=ID.COMPANY
    CALL F.WRITE(FN.VISA.TC40.OUT.FILE,Y.ID,R.ARRAY)


RETURN

END
