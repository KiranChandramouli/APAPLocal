SUBROUTINE REDO.E.BLD.CARD.STK.REG(ENQ.DATA)
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* returns the list of IDs that is created to fetch stock register ID

*------------------------------------------------------------------------------------------------------
*APPLICATION
* build routine to be attached in the enquiry REDO.CARD.STOCK.REGISTER
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.E.BLD.STOCK.REGISTER
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO               REFERENCE         DESCRIPTION
*08.03.2011      Swaminathan     ODR-2010-03-0400   INITIAL CREATION
*
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.USER
    $INSERT I_F.REDO.CARD.SERIES.PARAM

    GOSUB PROCESS
RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
*  CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)
    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    Y.RECEIVE.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.RECEIVE.DEPT.CODE>
    Y.EMBOSS.DEPT.CODE =  R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.EMBOSS.DEPT.CODE>

    FN.STOCK.REGISTER ='F.REDO.STOCK.REGISTER'
    F.STOCK.REGISTER = ''
    CALL OPF(FN.STOCK.REGISTER,F.STOCK.REGISTER)
    Y.ID = ''

    Y.FIN = R.COMPANY(EB.COM.FINANCIAL.COM)
    Y.COMPANY = ENQ.DATA<4,1>
*    Y.COMPANY=FIELD(Y.COMPANY,'-',1)
    CHK.DEPT.SEL=FIELD(Y.COMPANY,'-',2)
    CHK.COMP.SEL= FIELD(Y.COMPANY,'-',1)

    USR.DPT=R.USER<EB.USE.DEPARTMENT.CODE>

    USR.EMBOSS.DPT=R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.USR.EMB.DPT>
    Y.FLAG.USR.EMBOSS=0

    LOCATE USR.DPT IN USR.EMBOSS.DPT<1,1> SETTING POS.DPT THEN
        Y.FLAG.USR.EMBOSS=1
    END

    IF ID.COMPANY NE CHK.COMP.SEL THEN
        ENQ.ERROR='EB-REDO.DAO.NOT.VALID'
        RETURN

    END

* ENQ.ERROR='EB-REDO.DAO.NOT.VALID'
*BALA -CHANGE
    Y.COMPANY='CARD.':Y.COMPANY
    FINDSTR "-" IN Y.COMPANY SETTING VAR1,VAR2 THEN

        IF CHK.COMP.SEL NE R.COMPANY(EB.COM.FINANCIAL.COM) AND CHK.DEPT.SEL EQ Y.EMBOSS.DEPT.CODE THEN
            ENQ.ERROR='EB-REDO.DAO.NOT.VALID'
            RETURN
        END

        BEGIN CASE

            CASE Y.FLAG.USR.EMBOSS EQ 1 AND CHK.DEPT.SEL EQ Y.RECEIVE.DEPT.CODE
                ENQ.ERROR='EB-REDO.DAO.NOT.VALID'
                RETURN

            CASE Y.FLAG.USR.EMBOSS EQ 0 AND CHK.DEPT.SEL NE Y.RECEIVE.DEPT.CODE

                ENQ.ERROR='EB-REDO.DAO.NOT.VALID'
                RETURN

        END CASE


        Y.ID=Y.COMPANY
        SEL.CMD =" SELECT ":FN.STOCK.REGISTER:" WITH @ID EQ ":Y.ID
    END ELSE
        BEGIN CASE
            CASE Y.FLAG.USR.EMBOSS EQ 0
                Y.ID=Y.COMPANY:'-':Y.RECEIVE.DEPT.CODE
            CASE Y.FLAG.USR.EMBOSS EQ 1

                Y.ID=Y.COMPANY:'-':Y.EMBOSS.DEPT.CODE

        END CASE

        SEL.CMD =" SELECT ":FN.STOCK.REGISTER:" WITH @ID EQ ":Y.ID
    END
*BALA -CHANGE
* IF Y.COMPANY EQ Y.FIN THEN
*     Y.ID = 'CARD.':Y.FIN:'...'
*     SEL.CMD =" SELECT ":FN.STOCK.REGISTER:" WITH @ID LIKE ":Y.ID
* END ELSE
*     Y.ID = 'CARD.':Y.COMPANY:'-':Y.RECEIVE.DEPT.CODE
*     SEL.CMD =" SELECT ":FN.STOCK.REGISTER:" WITH @ID EQ ":Y.ID
* END
*bala change end
    CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,NO.OF.REC,'',Y.ERR)
    Y.ARRAY = SEL.CMD.LIST
    CHANGE @FM TO ' ' IN Y.ARRAY
    ENQ.DATA<2,1> = "@ID"
    ENQ.DATA<3,1> = "EQ"
    ENQ.DATA<4,1> = Y.ARRAY

RETURN
*------------------------------------------------------------
END
