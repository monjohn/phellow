defmodule Phellow.ContentTest do
  use Phellow.DataCase

  alias Phellow.Content

  describe "boards" do
    alias Phellow.Content.Board

    @valid_attrs %{img_url: "some img_url", title: "some title"}
    @update_attrs %{img_url: "some updated img_url", title: "some updated title"}
    @invalid_attrs %{img_url: nil, title: nil}

    def board_fixture(attrs \\ %{}) do
      {:ok, board} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_board()

      board
    end

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Content.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Content.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      assert {:ok, %Board{} = board} = Content.create_board(@valid_attrs)
      assert board.img_url == "some img_url"
      assert board.title == "some title"
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      assert {:ok, %Board{} = board} = Content.update_board(board, @update_attrs)
      assert board.img_url == "some updated img_url"
      assert board.title == "some updated title"
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_board(board, @invalid_attrs)
      assert board == Content.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Content.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Content.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Content.change_board(board)
    end
  end

  describe "lists" do
    alias Phellow.Content.List

    @valid_attrs %{position: 42, title: "some title"}
    @update_attrs %{position: 43, title: "some updated title"}
    @invalid_attrs %{position: nil, title: nil}

    def list_fixture(attrs \\ %{}) do
      {:ok, list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_list()

      list
    end

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Content.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Content.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      assert {:ok, %List{} = list} = Content.create_list(@valid_attrs)
      assert list.position == 42
      assert list.title == "some title"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      assert {:ok, %List{} = list} = Content.update_list(list, @update_attrs)
      assert list.position == 43
      assert list.title == "some updated title"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_list(list, @invalid_attrs)
      assert list == Content.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Content.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Content.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Content.change_list(list)
    end
  end
end
